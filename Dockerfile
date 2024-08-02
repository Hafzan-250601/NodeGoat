# Stage 1: Build the application and install dependencies
FROM node:12-alpine AS build

ENV WORKDIR /usr/src/app/
WORKDIR $WORKDIR

# Copy package.json and package-lock.json
COPY package*.json $WORKDIR

# Install production dependencies and the Contrast agent
RUN npm install --production --no-cache && \
    npm install @contrast/agent --no-cache

# Stage 2: Create the final image
FROM node:12-alpine

ENV USER node
ENV WORKDIR /home/$USER/app
WORKDIR $WORKDIR

# Copy node_modules from the build stage
COPY --from=build /usr/src/app/node_modules node_modules

# Change ownership of the working directory
RUN chown $USER:$USER $WORKDIR

# Copy the application code and set ownership
COPY --chown=node . $WORKDIR

COPY contrast_security.yaml $WORKDIR

# In production environment uncomment the next line
# RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR

# Switch to non-root user
USER $USER

# Expose the application port
EXPOSE 4000

# Start the application with the Contrast agent
CMD ["node", "--require", "@contrast/agent", "app.js"]
