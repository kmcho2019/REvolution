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

    // Separate 1-bit registers for falling and direction
    // direction: 0 = left, 1 = right
    reg falling;
    reg direction;

    // Combinational logic for next falling and next direction
    wire falling_next;
    wire direction_next;

    // Falling logic: if ground lost, start falling; if ground regained, stop falling
    assign falling_next = (falling) ? (ground ? 1'b0 : 1'b1)
                                   : (ground ? 1'b0 : 1'b1);

    // Direction logic:
    // When not falling, update direction on bumps
    // If bumped on left or right (including both), flip direction accordingly
    // If falling or ground just lost, direction remains unchanged
    // The bump during falling or ground edge cycle does not affect direction
    wire bumped = bump_left | bump_right;
    wire bumped_both = bump_left & bump_right;

    // Calculate next direction only if not falling, else hold current
    assign direction_next = (!falling) ? (
                                bumped ? (
                                    // Flip direction when bumped on either or both sides
                                    ~direction
                                ) : direction
                            ) : direction;

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;      // walking state
            direction <= 1'b0;      // walk left
        end else begin
            falling   <= falling_next;
            direction <= direction_next;
        end
    end

    // Outputs decoded from falling and direction registers
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule