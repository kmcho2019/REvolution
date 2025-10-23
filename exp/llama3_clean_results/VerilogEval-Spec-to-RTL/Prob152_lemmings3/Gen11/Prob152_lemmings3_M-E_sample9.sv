module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define states using one-hot encoding for better area and performance
reg [2:0] state;

// Define the walking direction
reg direction;

// Define the pipeline registers for state transitions
reg [2:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b001; // Initial state: walking
        direction <= 1'b0; // Initial direction: left
    end else begin
        // Update the state based on the next state
        state <= next_state;
        
        // Update the direction based on the current state and inputs
        case (state)
            3'b001: begin // Walking
                if (bump_left &&!direction) begin
                    direction <= 1'b1; // Change direction to right
                end else if (bump_right && direction) begin
                    direction <= 1'b0; // Change direction to left
                end
            end
            3'b010: begin // Falling
                // No change in direction while falling
            end
            3'b100: begin // Digging
                // No change in direction while digging
            end
        endcase
    end
end

always @(*) begin
    // Default next state is the current state
    next_state = state;
    
    // Determine the next state based on the current state and inputs
    case (state)
        3'b001: begin // Walking
            if (!ground) begin
                next_state = 3'b010; // Transition to falling
            end else if (dig) begin
                next_state = 3'b100; // Transition to digging
            end
        end
        3'b010: begin // Falling
            if (ground) begin
                next_state = 3'b001; // Transition back to walking
            end
        end
        3'b100: begin // Digging
            if (!ground) begin
                next_state = 3'b010; // Transition to falling
            end
        end
    endcase
end

// Assign outputs based on the current state and direction
assign walk_left = (state == 3'b001 &&!direction);
assign walk_right = (state == 3'b001 && direction);
assign aaah = (state == 3'b010);
assign digging = (state == 3'b100);

endmodule