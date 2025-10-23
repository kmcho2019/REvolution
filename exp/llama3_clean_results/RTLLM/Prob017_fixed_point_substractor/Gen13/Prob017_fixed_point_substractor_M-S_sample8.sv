module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

always @(*) begin
    c = a - b;  // Directly assign the result of the subtraction to the output 'c'
end

endmodule

// Example testbench code to demonstrate correct instantiation and usage.
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
       .a(a),  // First N-bit fixed-point input operand
       .b(b),  // Second N-bit fixed-point input operand
       .c(c)   // N-bit output representing the result of the fixed-point subtraction
    );

    initial begin
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        #100;  // Delay to observe the output
        $display("Result: %d", c);  // Display the result
    end

endmodule