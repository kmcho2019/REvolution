module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
enum logic [0:0] {LEFT, RIGHT} state, next_state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= (bump_left && (state == LEFT)) ? RIGHT :
                  (bump_right && (state == RIGHT)) ? LEFT :
                  state;
    end
end

// Define combinational logic for outputs
assign walk_left = (state == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == RIGHT) ? 1'b1 : 1'b0;

endmodule