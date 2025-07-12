module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

assign c = a - b;

endmodule

module fixed_point_subtractor_tb;
    parameter Q = 8,  // Number of fractional bits
              N = 16;  // Total number of bits
    
    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction
    
    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
       .a(a),  // Connect input a
       .b(b),  // Connect input b
       .c(c)   // Connect output c
    );
    
    initial begin
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        #10;  // Wait for 10 time units
        $display("Result: %d", c);  // Display the result
        
        a = 0;
        b = 0;
        #10;  // Wait for 10 time units
        $display("Result when a == 0 and b == 0: %d", c);  // Display the result when a equals b
        
        a = -10;
        b = -5;
        #10;  // Wait for 10 time units
        $display("Result for negative inputs: %d", c);  // Display the result for negative inputs
        
        $finish;
    end
endmodule