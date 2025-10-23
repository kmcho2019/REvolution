module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

// Internal wires
wire [N-1:0] a_abs, b_abs;  // Absolute values of a and b
wire [N-1:0] diff;  // Difference between a and b
wire sign_a, sign_b;  // Sign bits of a and b
wire sign_c;  // Sign bit of the result

// Detect sign bits
assign sign_a = a[N-1];
assign sign_b = b[N-1];

// Calculate absolute values
assign a_abs = (sign_a) ? (~a + 1) : a;
assign b_abs = (sign_b) ? (~b + 1) : b;

// Perform subtraction
assign diff = (sign_a == sign_b) ? (a_abs - b_abs) : (a_abs + b_abs);

// Determine the sign of the result
assign sign_c = (sign_a == sign_b) ? sign_a : (a_abs >= b_abs) ? ~sign_a : sign_b;

// Combine the sign and magnitude of the result
always @(*) begin
    if (diff == 0) begin
        c = 0;
    end else if (sign_c) begin
        c = ~diff + 1;
    end else begin
        c = diff;
    end
end

endmodule

// Testbench
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        a = 10;
        b = 5;
        #100;
        $display("Result: %d", c);
        $finish;
    end

endmodule