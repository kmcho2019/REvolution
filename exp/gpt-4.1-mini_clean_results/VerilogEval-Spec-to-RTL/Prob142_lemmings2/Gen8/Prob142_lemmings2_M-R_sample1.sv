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

    // Separate state bits
    reg falling;
    reg direction; // 0 = left, 1 = right

    // Next state combinational logic
    wire next_falling;
    wire next_direction;

    // Falling updates
    assign next_falling = falling ? (ground ? 1'b0 : 1'b1) : (ground ? 1'b0 : 1'b1);

    // Direction updates: only when not falling and on bumps
    wire bump = bump_left | bump_right;
    assign next_direction = falling ? direction :
                            bump ? ~direction :
                            direction;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;
            direction <= 1'b0; // walk left on reset
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule