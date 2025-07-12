module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Stage 1: Sign Analysis and Operand Preparation
reg signed [N-1:0] a_stage1;
reg signed [N-1:0] b_stage1;
reg sign_a, sign_b;
reg invert_a, invert_b;

always @(*) begin
    sign_a = a[N-1]; // Sign bit of a
    sign_b = b[N-1]; // Sign bit of b
    
    // Prepare operands based on signs
    if (sign_a == sign_b) begin
        a_stage1 = a;
        b_stage1 = b;
        invert_a = 1'b0;
        invert_b = 1'b0;
    end else if (sign_a == 1'b1 && sign_b == 1'b0) begin
        a_stage1 = -a; // Invert a
        b_stage1 = b;
        invert_a = 1'b1;
        invert_b = 1'b0;
    end else begin
        a_stage1 = a;
        b_stage1 = -b; // Invert b
        invert_a = 1'b0;
        invert_b = 1'b1;
    end
end

// Stage 2: Subtraction and Result Generation
always @(*) begin
    c = a_stage1 - b_stage1;
    
    // Handle edge cases and apply final sign adjustments
    if (c == 0) begin
        c = 0; // Ensure sign bit is 0 for zero result
    end else if (invert_a == 1'b1) begin
        c = -c; // Adjust sign if a was inverted
    end else if (invert_b == 1'b1) begin
        // No sign adjustment needed if b was inverted
    end
end

endmodule

// Testbench
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
        #10; $display("Result: %d", c);
        a = -10; b = 5;
        #10; $display("Result: %d", c);
        a = 0; b = 0;
        #10; $display("Result: %d", c);
        $finish;
    end
    
endmodule