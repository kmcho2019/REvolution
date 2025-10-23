module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);
    reg [1:0] state, next_state;
    wire falling = state[1];
    wire dir     = state[0];

    // Gate bump inputs when falling to reduce toggling
    wire bump_left_g = bump_left & ~falling;
    wire bump_right_g = bump_right & ~falling;

    always @* begin
        if (falling) begin
            next_state = ground ? {1'b0, dir} : state;
        end else begin
            if (!ground)
                next_state = {1'b1, dir};
            else if (bump_left_g && bump_right_g)
                next_state = {1'b0, ~dir};
            else if (bump_left_g)
                next_state = {1'b0, 1'b1};
            else if (bump_right_g)
                next_state = {1'b0, 1'b0};
            else
                next_state = state;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00;
        else
            state <= next_state;
    end

    // Register outputs to reduce glitches and switching power
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
            aaah       <= 1'b0;
        end else begin
            aaah       <= falling;
            walk_left  <= ~falling & ~dir;
            walk_right <= ~falling &  dir;
        end
    end
endmodule