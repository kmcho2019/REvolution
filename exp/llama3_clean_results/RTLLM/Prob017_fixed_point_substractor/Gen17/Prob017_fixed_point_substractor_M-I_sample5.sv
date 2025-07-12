module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

// Internal signal for result
reg signed [N-1:0] res;  // Result of the subtraction operation

// Combined logic for sign detection, absolute value calculation, and subtraction
always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different sign
        if (a[N-1] == 1) begin  // a is negative
            res = (~a + 1) - b;  // Subtract b from absolute value of a
            if (res[N-1] == 1) begin  // If result is negative, make it positive
                res = ~res + 1;
            end
        end else begin  // b is negative
            res = a - (~b + 1);  // Subtract absolute value of b from a
        end
    end
    if (res == 0) begin  // Zero handling
        res = 0;
    end
    c = res;  // Assign result to output
end

endmodule

module testbench #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
);
    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),  // First N-bit fixed-point input operand
        .b(b),  // Second N-bit fixed-point input operand
        .c(c)  // N-bit output representing the result of the fixed-point subtraction
    );

    initial begin
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        #100;  // Delay to observe the output
        $display("Result: %d", c);  // Display the result
    end

endmodule