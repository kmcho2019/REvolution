module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    reg [1:0] state, next_state;
    wire falling = state[1];
    wire dir = state[0]; // 0=left, 1=right

    always @(*) begin
        next_state = state;
        if (!falling) begin
            if (!ground)
                next_state = {1'b1, dir};
            else if (bump_left && bump_right)
                next_state = {1'b0, ~dir};
            else if (bump_left)
                next_state = 2'b01; // walk right
            else if (bump_right)
                next_state = 2'b00; // walk left
        end else if (ground) begin
            next_state = {1'b0, dir};
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left
        else
            state <= next_state;
    end

    assign aaah = falling;
    assign walk_left = ~falling & ~dir;
    assign walk_right = ~falling & dir;

endmodule