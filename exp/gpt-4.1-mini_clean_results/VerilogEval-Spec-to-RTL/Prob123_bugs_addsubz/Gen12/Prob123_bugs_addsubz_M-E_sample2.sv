module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] sum_with_carry;

    // Conditionally invert b and add carry_in (do_sub) for two's complement subtraction
    assign b_xor = b ^ {8{do_sub}};
    assign sum_with_carry = {1'b0, a} + {1'b0, b_xor} + do_sub;

    // Lower 8 bits as output
    assign out = sum_with_carry[7:0];

    // Zero detection logic updated combinationally
    always @(*) begin
        result_is_zero = ~|out;  // Reduction NOR to set zero flag
    end

endmodule