module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg signed [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Perform subtraction operation
    res = a - b;
    
    // Explicitly handle the case where the result is zero
    if (res == 0) begin
        c = 0;  // Set the output to 0 when the result is zero
    end else begin
        c = res;  // Otherwise, assign the result to the output
    end
end

endmodule

// Example testbench to demonstrate usage and correct output declaration
module fixed_point_subtractor_tb;
    parameter Q = 8,  // Number of fractional bits
              N = 16;  // Total number of bits
    
    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction
    
    fixed_point_subtractor #(
        .Q(Q),  // Correctly pass the parameter Q
        .N(N)   // Correctly pass the parameter N
    ) uut (
       .a(a),
       .b(b),
       .c(c)
    );
    
    initial begin
        // Initialize inputs
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        
        #10;  // Wait for 10 time units
        $display("Result: %d", c);  // Display the result
        
        // Test case with zero result
        a = 10;
        b = 10;
        
        #10;  // Wait for 10 time units
        $display("Result when a == b: %d", c);  // Display the result when a equals b
        
        $finish;
    end
endmodule