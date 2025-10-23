module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    reg [8:0] sum_with_carry;

    always @(*) begin
        // Add or subtract depending on do_sub:
        // If do_sub=0: sum_with_carry = a + b + 0
        // If do_sub=1: sum_with_carry = a + (~b) + 1 (two's complement subtraction)
        sum_with_carry = a + (~b & {8{do_sub}}) + do_sub;

        // Assign lower 8 bits as output
        out = sum_with_carry[7:0];

        // result_is_zero is high if all bits of out are zero
        result_is_zero = ~|out;
    end

endmodule