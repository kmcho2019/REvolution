module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // One-hot state encoding as separate registers
    reg before_first_one;
    reg after_first_one;

    // Next state signals as wires
    wire next_before_first_one;
    wire next_after_first_one;

    // Next output signal
    wire next_z;

    // Next state logic
    assign next_before_first_one = before_first_one & ~x;
    assign next_after_first_one  = after_first_one | (before_first_one & x);

    // Output logic (Moore output depends only on state)
    // Before first one: output = x (just passed input)
    // After first one: output = inverted x
    assign next_z = before_first_one ? x : ~x;

    // State registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            before_first_one <= 1'b1;
            after_first_one  <= 1'b0;
            z                <= 1'b0;
        end else begin
            before_first_one <= next_before_first_one;
            after_first_one  <= next_after_first_one;
            z                <= next_z;
        end
    end

endmodule