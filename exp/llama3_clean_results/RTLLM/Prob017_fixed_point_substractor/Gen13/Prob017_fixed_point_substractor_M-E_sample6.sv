module sign_bit_handler #(
    parameter N = 16
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg sign
);

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        sign = a[N-1];
    end else if (a[N-1] == 0) begin // a is positive
        if (a >= -b) begin
            sign = 0; // Result is positive
        end else begin
            sign = 1; // Result is negative
        end
    end else begin // a is negative
        if (-a >= b) begin
            sign = 1; // Result is negative
        end else begin
            sign = 0; // Result is positive
        end
    end
end

endmodule

module integer_part_subtractor #(
    parameter N = 16,
    parameter Q = 8
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-Q-1:0] result
);

always @(*) begin
    result = (a >> Q) - (b >> Q);
end

endmodule

module fractional_part_subtractor #(
    parameter Q = 8
)(
    input signed [Q-1:0] a,
    input signed [Q-1:0] b,
    output reg signed [Q-1:0] result
);

always @(*) begin
    result = a - b;
end

endmodule

module fixed_point_subtractor #(
    parameter N = 16,
    parameter Q = 8
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

wire signed [N-Q-1:0] int_result;
wire signed [Q-1:0] frac_result;
wire sign;

sign_bit_handler sbh (
    .a(a),
    .b(b),
    .sign(sign)
);

integer_part_subtractor ips (
    .a(a),
    .b(b),
    .result(int_result)
);

fractional_part_subtractor fps (
    .a(a & ((1 << Q) - 1)),
    .b(b & ((1 << Q) - 1)),
    .result(frac_result)
);

always @(*) begin
    c = {sign, int_result, frac_result};
    
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
    parameter N = 16;
    parameter Q = 8;
    
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;
    
    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
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