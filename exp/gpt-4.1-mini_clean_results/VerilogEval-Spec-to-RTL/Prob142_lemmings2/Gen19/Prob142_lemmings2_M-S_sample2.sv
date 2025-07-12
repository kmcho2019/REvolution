module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);
    reg [1:0] state, next_state;
    wire falling = state[1];
    wire dir     = state[0];

    always @* begin
        if (falling) begin
            next_state = ground ? {1'b0, dir} : state;
        end else begin
            if (!ground) next_state = {1'b1, dir};
            else if (bump_left && bump_right) next_state = {1'b0, ~dir};
            else if (bump_left) next_state = {1'b0, 1'b1};
            else if (bump_right) next_state = {1'b0, 1'b0};
            else next_state = state;
        end
    end

    always @(posedge clk or posedge areset)
        if (areset) state <= 2'b00; else state <= next_state;

    assign aaah       = falling;
    assign walk_left  = ~falling & ~dir;
    assign walk_right = ~falling &  dir;
endmodule