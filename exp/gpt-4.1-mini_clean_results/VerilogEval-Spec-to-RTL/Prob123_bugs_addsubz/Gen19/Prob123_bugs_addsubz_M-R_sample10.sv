module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    // Function to perform 8-bit adder-subtractor using ripple carry logic
    function [8:0] add_sub_8bit;
        input [7:0] operand_a;
        input [7:0] operand_b;
        input       sub; // 0=add, 1=sub

        reg [7:0] b_xor;
        reg [8:0] carry;
        reg [7:0] sum;
        integer i;

        begin
            b_xor = operand_b ^ {8{sub}};
            carry[0] = sub; // Initial carry-in is do_sub

            for (i = 0; i < 8; i = i + 1) begin
                sum[i] = operand_a[i] ^ b_xor[i] ^ carry[i];
                carry[i+1] = (operand_a[i] & b_xor[i]) | (operand_a[i] & carry[i]) | (b_xor[i] & carry[i]);
            end

            add_sub_8bit = {carry[8], sum}; // Return 9-bit result (carry out + sum)
        end
    endfunction

    reg [8:0] sum_with_carry;

    always @(*) begin
        sum_with_carry = add_sub_8bit(a, b, do_sub);
        out = sum_with_carry[7:0];
        result_is_zero = ~|out; // Reduction NOR: high if out is zero
    end

endmodule