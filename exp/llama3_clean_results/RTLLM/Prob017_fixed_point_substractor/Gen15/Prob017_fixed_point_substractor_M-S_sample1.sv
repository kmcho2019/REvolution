module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

assign c = a - b;  // Directly assign the result of the subtraction to the output 'c'

endmodule

// Simplified testbench to demonstrate correct instantiation and usage.
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a = 10;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b = 5;   // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
       .a(a),  // First N-bit fixed-point input operand
       .b(b),  // Second N-bit fixed-point input operand
       .c(c)   // N-bit output representing the result of the fixed-point subtraction
    );

    initial begin
        #100;  // Delay to observe the output
        $display("Result: %d", c);  // Display the result
        $finish;
    end

endmodule