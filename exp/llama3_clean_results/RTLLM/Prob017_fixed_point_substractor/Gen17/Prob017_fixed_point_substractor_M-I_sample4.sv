module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

// Perform subtraction using synthesizer-friendly constructs
assign c = a + (~b + 1);  // Use "+" operator with negated operand and add 1 for two's complement

endmodule

// Testbench
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    // Correctly instantiate the module with parameters
    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
       .a(a),
       .b(b),
       .c(c)
    );

    initial begin
        a = 10;
        b = 5;
        #100;
        $display("Result: %d", c);
        $finish;
    end

endmodule