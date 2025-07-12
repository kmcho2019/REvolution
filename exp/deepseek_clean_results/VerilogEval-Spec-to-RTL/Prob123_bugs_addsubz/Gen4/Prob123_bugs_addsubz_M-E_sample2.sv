module TopModule (
    input do_sub,          // 1 for subtraction, 0 for addition
    input [7:0] a,         // First operand
    input [7:0] b,         // Second operand
    output reg [7:0] out,  // Result of operation
    output reg result_is_zero  // Flag indicating zero result
);

    wire [7:0] b_modified = b ^ {8{do_sub}};  // Conditional complement
    wire [7:0] sum, carry;
    wire [7:0] final_sum;
    wire zero_detect;

    // Carry-save addition stage
    assign sum = a ^ b_modified;
    assign carry = (a & b_modified) << 1;

    // Final addition with carry-in for subtraction
    assign final_sum = sum + carry + do_sub;

    // Parallel zero detection using OR reduction
    assign zero_detect = ~|final_sum;

    always @(*) begin
        out = final_sum;
        result_is_zero = zero_detect;
    end

endmodule