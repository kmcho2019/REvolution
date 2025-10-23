module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Internal wires for stage 1 (subtraction)
wire signed [N-1:0] sub_result;

// Internal wires for stage 2 (precision adjustment and saturation)
reg signed [N-1:0] adjusted_result;

// Stage 1: Perform subtraction
assign sub_result = a - b;

// Stage 2: Precision adjustment and saturation logic
always @(*) begin
    // Precision adjustment
    adjusted_result = sub_result;
    
    // Saturation logic
    if (adjusted_result >= (1 << (N-1)) - (1 << Q)) begin
        adjusted_result = (1 << (N-1)) - 1; // Saturate at maximum value
    end else if (adjusted_result < -(1 << (N-1))) begin
        adjusted_result = -(1 << (N-1)); // Saturate at minimum value
    end
    
    // Explicitly handle zero result
    if (adjusted_result == 0) begin
        adjusted_result = 0; // Ensure sign bit is 0
    end
end

// Assign final result
always @(*) begin
    c = adjusted_result;
end

endmodule

// Example testbench
module testbench;
    parameter Q = 8;
    parameter N = 16;
    
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;
    
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),
        .b(b),
        .c(c)
    );
    
    initial begin
        // Test same sign subtraction
        a = 10; b = 5;
        #10; $display("Result (same sign): %d", c);
        
        // Test different sign subtraction
        a = 10; b = -5;
        #10; $display("Result (different sign): %d", c);
        
        // Test edge case: zero inputs
        a = 0; b = 0;
        #10; $display("Result (zero inputs): %d", c);
        
        // Test edge case: maximum value
        a = (1 << (N-1)) - 1; b = 0;
        #10; $display("Result (max value): %d", c);
        
        // Test edge case: minimum value
        a = -(1 << (N-1)); b = 0;
        #10; $display("Result (min value): %d", c);
        
        $finish;
    end
    
endmodule