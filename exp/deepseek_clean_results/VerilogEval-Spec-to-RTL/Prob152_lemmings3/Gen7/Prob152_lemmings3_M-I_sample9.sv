module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding with direction bit (state[2] = direction)
    // Gray coding for state transitions to reduce glitching
    parameter WALKING = 3'b000;  // [2]=direction, [1:0]=00
    parameter FALLING = 3'b001;  // direction preserved
    parameter DIGGING = 3'b011;  // direction preserved
    
    reg [2:0] state, next_state;
    wire direction = state[2];  // MSB is direction

    // Clock gating signals
    wire direction_update = (state[1:0] == 2'b00); // Only update direction in WALKING state

    // State transition logic (simplified)
    always @(*) begin
        next_state = state;
        
        case (state[1:0])
            2'b00: begin // WALKING
                if (!ground) begin
                    next_state = {direction, 2'b01}; // FALLING
                end else if (dig) begin
                    next_state = {direction, 2'b11}; // DIGGING
                end
            end
            
            2'b01: begin // FALLING
                if (ground) begin
                    next_state = {direction, 2'b00}; // WALKING
                end
            end
            
            2'b11: begin // DIGGING
                if (!ground) begin
                    next_state = {direction, 2'b01}; // FALLING
                end
            end
        endcase
    end

    // Direction change logic (simplified and synchronous)
    wire direction_change;
    assign direction_change = (state[1:0] == 2'b00) && 
                            ((bump_left && !direction) || (bump_right && direction));

    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 3'b000; // WALKING left
        end else begin
            if (direction_update && direction_change) begin
                state <= {~direction, next_state[1:0]}; // Toggle direction
            end else begin
                state <= next_state;
            end
        end
    end

    // Output logic (simplified)
    assign walk_left = (state[1:0] == 2'b00) & ~state[2];
    assign walk_right = (state[1:0] == 2'b00) & state[2];
    assign aaah = (state[1:0] == 2'b01);
    assign digging = (state[1:0] == 2'b11);

endmodule