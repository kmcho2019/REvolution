module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_operand;
    reg [7:0] arithmetic_result;

    // Conditional inversion for subtraction
    assign b_operand = b ^ {8{do_sub}};

    // Arithmetic operation in always block
    always @(*) begin
        arithmetic_result = a + b_operand + do_sub;
    end

    // Output assignments
    assign out = arithmetic_result;
    assign result_is_zero = (arithmetic_result == 8'd0);

endmodule