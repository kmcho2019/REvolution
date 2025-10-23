module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform addition or subtraction based on the signs
always @(*) begin
    if (sign_a == sign_b) begin
        // Both operands have the same sign, perform addition
        res = a + b;
    end else begin
        // Operands have different signs, perform subtraction
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
end

// Assign the result to the output port
assign c = res;

endmodule