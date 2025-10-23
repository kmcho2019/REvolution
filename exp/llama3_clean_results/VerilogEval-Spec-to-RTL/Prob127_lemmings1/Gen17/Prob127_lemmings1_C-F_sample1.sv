module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
typedef enum logic {LEFT = 0, RIGHT = 1} state_t;

reg state; // Using a 1-bit state variable

// Define sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        case (state)
            LEFT: state <= bump_left ? RIGHT : LEFT;
            RIGHT: state <= bump_right ? LEFT : RIGHT;
        endcase
    end
end

// Define outputs
assign walk_left = ~state;
assign walk_right = state;

endmodule