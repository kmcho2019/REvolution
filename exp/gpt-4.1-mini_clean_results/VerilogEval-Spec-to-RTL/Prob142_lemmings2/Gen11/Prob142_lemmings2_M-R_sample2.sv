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

    // Separate state bits: falling and direction
    reg falling;
    reg direction; // 0 = left, 1 = right

    // Next state logic for falling and direction
    wire falling_next;
    wire direction_next;

    // Falling next state logic:
    // If currently not falling and ground is lost, start falling.
    // If falling and ground returns, stop falling.
    // Else keep current falling state.
    assign falling_next = falling ? (ground ? 1'b0 : 1'b1) : (ground ? 1'b0 : 1'b1);

    // Direction next state logic:
    // Update only if not falling and ground is present.
    // Flip direction if bumped on either or both sides.
    // Else keep current direction.
    wire bumped = bump_left | bump_right;
    assign direction_next = (falling || !ground) ? direction :
                            bumped ? ~direction : direction;

    // Sequential logic with async reset for falling and direction
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling  <= 1'b0;   // not falling on reset
            direction <= 1'b0;  // walk_left on reset
        end else begin
            falling  <= falling_next;
            direction <= direction_next;
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule