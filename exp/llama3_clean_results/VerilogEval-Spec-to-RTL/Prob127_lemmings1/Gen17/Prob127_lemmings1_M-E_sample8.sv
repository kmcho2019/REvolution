module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define an enumeration for the states
typedef enum logic {LEFT = 0, RIGHT = 1} state_t;

reg state; // Using a 1-bit state variable
reg next_state; // Next state variable for LUT

// Lookup table for next state
always @(*) begin
    case (state)
        LEFT: next_state = bump_left? RIGHT : LEFT;
        RIGHT: next_state = bump_right? LEFT : RIGHT;
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        state <= next_state; // Update state
    end
end

// Output logic
always @(*) begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule