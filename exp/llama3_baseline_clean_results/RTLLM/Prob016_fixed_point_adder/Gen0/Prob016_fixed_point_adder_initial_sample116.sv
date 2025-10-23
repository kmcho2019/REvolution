module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // If the MSBs of a and b are the same
        res = a + b;  // Perform absolute value addition
    end else begin
        if (a > b) begin  // If a is greater than b
            res = a - b;  // Perform a - b and set MSB to 0 (positive)
        end else begin
            res = b - a;  // Perform b - a
            // MSB of the result is set according to whether the result is zero or negative
        end
    end
end

assign c = res;  // Assign the result to output port c

endmodule