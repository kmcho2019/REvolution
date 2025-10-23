module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   wire [N-1:0] a,
    input   wire [N-1:0] b,
    output  wire [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign bits of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Compare the absolute values of a and b
wire greater_a = (a[N-1] == 0)? (a >= b) : ((~a + 1) >= (~b + 1));
wire greater_b = (b[N-1] == 0)? (b >= a) : ((~b + 1) >= (~a + 1));

// Perform the required arithmetic operation
always @(*) begin
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = a + b;
    end else if (greater_a) begin
        // Absolute value subtraction: a - b
        res = a - b;
    end else begin
        // Absolute value subtraction: b - a
        res = b - a;
    end
end

// Assign the result to the output
assign c = res;

endmodule