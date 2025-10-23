module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] b_xor;
    reg [8:0] sum_with_carry;

    always @(*) begin
        // Prepare operand B: XOR with do_sub to select add or subtract
        b_xor = b ^ {8{do_sub}};

        // Perform addition with carry-in do_sub to effect subtraction if needed
        sum_with_carry = a + b_xor + do_sub;

        // Output is lower 8 bits of the sum
        out = sum_with_carry[7:0];

        // Zero flag: 1 if result is zero, else 0
        result_is_zero = ~|out;
    end

endmodule