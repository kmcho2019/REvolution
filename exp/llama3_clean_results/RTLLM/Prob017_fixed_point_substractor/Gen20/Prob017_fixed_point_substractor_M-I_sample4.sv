module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

assign c = a - b;  // Direct subtraction

// No explicit overflow/underflow handling needed as
// signed arithmetic in Verilog will automatically wrap around.

endmodule

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
        // Test case 1: Normal subtraction
        a = 10;  
        b = 5;   
        #10;  
        $display("Result: %d", c);  
    
        // Test case 2: a equals b
        a = 10;
        b = 10;
        #10;  
        $display("Result when a == b: %d", c);  
    
        // Test case 3: Maximum positive value
        a = {1'b1, {N-1{1'b1}}};
        b = 0;
        #10;  
        $display("Result for maximum positive value: %d", c);  
    
        // Test case 4: Minimum negative value
        a = 0;
        b = {1'b1, {N-1{1'b1}}};
        #10;  
        $display("Result for minimum negative value: %d", c);  
    
        // Test case 5: Overflow
        a = {1'b1, {N-1{1'b1}}};
        b = -{1'b1, {N-1{1'b0}}};
        #10;  
        $display("Result for overflow: %d", c);  
    
        // Test case 6: Underflow
        a = -{1'b1, {N-1{1'b0}}};
        b = {1'b1, {N-1{1'b1}}};
        #10;  
        $display("Result for underflow: %d", c);  
    
        $finish;
    end
endmodule