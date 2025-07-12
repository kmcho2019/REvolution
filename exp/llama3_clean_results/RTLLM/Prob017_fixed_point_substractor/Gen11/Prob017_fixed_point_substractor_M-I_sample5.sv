module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Perform subtraction considering signs and precision
always @(*) begin
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        // Same sign, direct subtraction
        c = a - b;
    end else begin
        // Different signs, add absolute values and determine sign
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (a > -b) begin
                c = a + (-b);
            end else begin
                c = -b + (-a);
            end
        end else begin
            // a is negative, b is positive
            if (-a > b) begin
                c = -a + (-b);
            end else begin
                c = b + (-a);
            end
        end
    end
    
    // Explicitly handle zero result
    if (c == 0) begin
        c = 0; // Ensure sign bit is 0 for zero result
    end
end

endmodule

// Enhanced testbench
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
        a = 10; b = 5;
        #10; $display("Result (10 - 5): %d", c);
        a = -10; b = 5;
        #10; $display("Result (-10 - 5): %d", c);
        a = 0; b = 0;
        #10; $display("Result (0 - 0): %d", c);
        a = -5; b = -10;
        #10; $display("Result (-5 - (-10)): %d", c);
        $finish;
    end
    
endmodule