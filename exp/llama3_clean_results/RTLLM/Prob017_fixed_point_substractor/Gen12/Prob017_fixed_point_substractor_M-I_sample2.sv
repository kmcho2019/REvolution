module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Directly perform subtraction and handle signs implicitly
always @(*) begin
    c = a - b;
    
    // Normalize the result if necessary
    if (c >= (1 << (N-1))) begin
        c = (1 << (N-1)) - 1; // Saturate at maximum value
    end
    else if (c < -(1 << (N-1))) begin
        c = -(1 << (N-1)); // Saturate at minimum value
    end
    
    // Handle zero result explicitly
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