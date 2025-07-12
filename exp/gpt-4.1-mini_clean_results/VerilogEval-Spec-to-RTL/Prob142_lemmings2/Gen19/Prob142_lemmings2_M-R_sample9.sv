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

    // Registers for falling state and walking direction
    reg falling;
    reg direction; // 0 = left, 1 = right

    // Combinational logic to determine next direction when walking
    wire next_direction;
    wire bumped = bump_left | bump_right;

    assign next_direction = (bumped && ~falling) ?
                           ((bump_left && bump_right) ? ~direction :
                            (bump_left ? 1'b1 : 1'b0))
                           : direction;

    // Sequential logic for falling state with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            falling <= 1'b0;
        else if (~ground)
            falling <= 1'b1;
        else if (ground && falling)
            falling <= 1'b0;
        else
            falling <= falling;
    end

    // Sequential logic for direction with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b0; // walk left
        else if (~falling)
            direction <= next_direction;
        else
            direction <= direction; // hold direction while falling
    end

    // Moore outputs from registers
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule