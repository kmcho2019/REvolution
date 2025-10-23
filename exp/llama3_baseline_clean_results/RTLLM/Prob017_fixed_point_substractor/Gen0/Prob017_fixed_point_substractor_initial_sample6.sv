module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg  [N-1:0] c   // N-bit output representing the result
);

    // Internal register to store the result
    reg [N-1:0] res;

    // Signs of the operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute values of the operands (ignoring the sign bit)
    wire [N-2:0] abs_a = sign_a ? {1'b0, {N-2{1'b1}} - a[N-2:0]} + 1 : a[N-2:0];
    wire [N-2:0] abs_b = sign_b ? {1'b0, {N-2{1'b1}} - b[N-2:0]} + 1 : b[N-2:0];

    // Perform subtraction or addition based on the signs
    wire [N-1:0] result;
    assign result = sign_a == sign_b ? (a - b) : (abs_a + abs_b);

    // Update the internal register
    always @(a, b) begin
        if (result == 0) begin
            res <= {N{1'b0}};  // Explicitly set result to zero
        end else if (sign_a == sign_b) begin
            res <= result;
        end else begin
            if ((abs_a > abs_b && sign_a) || (abs_a < abs_b && ~sign_a)) begin
                res <= {1'b0, abs_a + abs_b};
            end else begin
                res <= {1'b1, {N-2{1'b1}} - (abs_a + abs_b) + 1};
            end
        end
    end

    // Assign output
    assign c = res;

endmodule