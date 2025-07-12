module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

always_comb begin
    // Directly perform subtraction without separating integer and fractional parts
    // and let the synthesis tool handle the optimization
    c = a - b;
    
    // Explicitly handle overflow and underflow
    if (c > ((1 << (N-1)) - 1)) begin
        c = {1'b1, {N-1{1'b1}}};  // Maximum positive value
    end else if (c < -(1 << (N-1))) begin
        c = -{1'b1, {N-1{1'b0}}};  // Minimum negative value
    end
    
    // Handle zero result
    if (c == 0) begin
        c = 0;  // Ensure sign bit is 0 for zero result
    end
end

endmodule

// Testbench
module fixed_point_subtractor_tb;
    parameter Q = 8,  // Number of fractional bits
              N = 16;  // Total number of bits
    
    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction
    
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),  // Connect input a
        .b(b),  // Connect input b
        .c(c)   // Connect output c
    );
    
    initial begin
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        
        #10;  // Wait for 10 time units
        $display("Result: %d", c);  // Display the result
        
        a = 10;
        b = 10;
        
        #10;  // Wait for 10 time units
        $display("Result when a == b: %d", c);  // Display the result when a equals b
        
        a = {1'b1, {N-1{1'b1}}};
        b = -{1'b1, {N-1{1'b0}}};
        
        #10;  // Wait for 10 time units
        $display("Result for overflow: %d", c);  // Display the result for overflow
        
        a = -{1'b1, {N-1{1'b0}}};
        b = {1'b1, {N-1{1'b1}}};
        
        #10;  // Wait for 10 time units
        $display("Result for underflow: %d", c);  // Display the result for underflow
        
        $finish;
    end
endmodule