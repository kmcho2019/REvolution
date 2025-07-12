module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

// Internal signals
reg signed [N-1:0] res;  // Result of the subtraction operation
reg [N-1:0] a_abs;  // Absolute value of a
reg [N-1:0] b_abs;  // Absolute value of b
reg sign_a;  // Sign of a
reg sign_b;  // Sign of b
reg same_sign;  // Flag indicating same sign subtraction
reg [N-1:0] diff;  // Difference between a and b

// Sign detection
always @(*) begin
    sign_a = a[N-1];
    sign_b = b[N-1];
    same_sign = (sign_a == sign_b);
end

// Absolute value calculation
always @(*) begin
    a_abs = (sign_a)? (~a + 1) : a;
    b_abs = (sign_b)? (~b + 1) : b;
end

// Subtraction operation
always @(*) begin
    if (same_sign) begin
        res = a - b;
    end else begin
        diff = (a_abs > b_abs)? a_abs - b_abs : b_abs - a_abs;
        res = (a_abs > b_abs)? diff : (~diff + 1);
    end
end

// Output assignment
always @(*) begin
    c = res;
end

// Zero handling
always @(*) begin
    if (c == 0) begin
        c = 0;
    end
end

endmodule

// Example testbench code to demonstrate correct instantiation and usage.
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
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