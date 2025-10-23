module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
typedef enum {LEFT, RIGHT} state_t;

reg state;

// Define sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else if (bump_left) begin
        state <= RIGHT;
    end else if (bump_right) begin
        state <= LEFT;
    end
end

// Define outputs
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule