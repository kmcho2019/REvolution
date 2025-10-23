// Improved fixed_point_subtractor module
module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

always @(*) begin
    // Perform subtraction operation and assign result directly to output
    c = a - b;
    
    // Explicitly handle the case where the result is zero
    if (c == 0) begin
        c = 0;  // Set the output to 0 when the result is zero
    end
    
    // Check for overflow and underflow conditions
    if (c > {1'b1, {N-1{1'b0}}}) begin
        c = {1'b1, {N-1{1'b0}}};  // Handle overflow
    end else if (c < -{1'b1, {N-1{1'b0}}}) begin
        c = -{1'b1, {N-1{1'b0}}};  // Handle underflow
    end
end

endmodule

// Improved testbench
module fixed_point_subtractor_tb;
    parameter Q = 8,  // Number of fractional bits
              N = 16;  // Total number of bits
    
    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction
    
    // Correctly instantiate the fixed_point_subtractor module
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),  // Connect input a
        .b(b),  // Connect input b
        .c(c)   // Connect output c
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
        
        // Test case for overflow
        a = {1'b1, {N-1{1'b1}}};
        b = -{1'b1, {N-1{1'b0}}};
        
        #10;  // Wait for 10 time units
        $display("Result for overflow: %d", c);  // Display the result for overflow
        
        // Test case for underflow
        a = -{1'b1, {N-1{1'b0}}};
        b = {1'b1, {N-1{1'b1}}};
        
        #10;  // Wait for 10 time units
        $display("Result for underflow: %d", c);  // Display the result for underflow
        
        $finish;
    end
endmodule