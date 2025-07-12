module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate the absolute values of the inputs
wire [N-1:0] abs_a = sign_a? (~a + 1) : a;
wire [N-1:0] abs_b = sign_b? (~b + 1) : b;

// Perform addition or subtraction based on the signs
always @(*) begin
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (abs_a > abs_b) begin
            // a is greater than b
            res = a - b;
        end else begin
            // b is greater than a
            res = b - a;
        end
    end
end

// Assign the result to the output
assign c = res;

endmodule