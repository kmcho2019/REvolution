module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Separate integer and fractional parts using assign
wire signed [N-Q-1:0] a_int = a >> Q;
wire signed [Q-1:0] a_frac = a & ((1 << Q) - 1);
wire signed [N-Q-1:0] b_int = b >> Q;
wire signed [Q-1:0] b_frac = b & ((1 << Q) - 1);

// Perform subtraction in an always block
always @(*) begin
    if ((a[N-1] == b[N-1])) begin // Same sign subtraction
        c = ((a_int - b_int) << Q) + (a_frac - b_frac);
    end else begin // Different sign subtraction
        if (a[N-1] == 0) begin // a is positive
            c = ((a_int + b_int) << Q) + (a_frac + b_frac);
        end else begin // a is negative
            c = ((b_int - a_int) << Q) + (b_frac - a_frac);
        end
    end
    
    // Handle overflow and underflow
    if (c >= (1 << N)) begin
        c = (1 << N) - 1; // Saturate at maximum value
    end else if (c < -(1 << (N-1))) begin
        c = -(1 << (N-1)); // Saturate at minimum value
    end
    
    // Explicitly handle zero result
    if (c == 0) begin
        c = 0; // Ensure sign bit is 0
    end
end

endmodule

// Example testbench
module testbench;
    parameter Q = 8;
    parameter N = 16;
    
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;
    
    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
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
        a = (1 << N) - 1; b = 0;
        #10; $display("Result (max value): %d", c);
        
        $finish;
    end
    
endmodule