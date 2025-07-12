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

    // Registers for state bits: falling and direction
    reg falling, direction;

    // Next state signals
    wire next_falling;
    wire next_direction;

    // Falling next logic:
    // If currently falling, stay falling until ground returns
    // If not falling and ground lost, start falling
    assign next_falling = (falling) ? 
                          (~ground ? 1'b1 : 1'b0) :  // falling stays if no ground, else stop falling
                          (~ground ? 1'b1 : 1'b0);   // start falling if ground lost

    // Direction next logic:
    // Direction changes only if not falling and ground present
    // During falling or no ground, keep direction unchanged
    assign next_direction = (falling || !ground) ? 
                            direction :          // hold direction if falling or no ground (falling just started)
                            ( (bump_left && bump_right) ? ~direction : // both bumps flip direction
                              bump_left ? 1'b1 :                      // bump left means walk right
                              bump_right ? 1'b0 :                     // bump right means walk left
                              direction                              // no bumps: hold direction
                            );

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;  // start walking, so not falling
            direction <= 1'b0;  // walking left at reset
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Outputs from current state (Moore)
    assign aaah       = falling;
    assign walk_left  = (~falling) && (~direction);
    assign walk_right = (~falling) && direction;

endmodule