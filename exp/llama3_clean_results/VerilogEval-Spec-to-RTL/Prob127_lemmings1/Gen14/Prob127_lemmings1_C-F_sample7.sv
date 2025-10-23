module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

typedef enum logic {LEFT = 0, RIGHT = 1} state_t;

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        if (bump_left && bump_right) begin
            state <= ~state; // Switch direction
        end else if (state == LEFT) begin
            state <= bump_left ? RIGHT : LEFT;
        end else begin
            state <= bump_right ? LEFT : RIGHT;
        end
    end
end

assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule