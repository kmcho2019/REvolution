module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin // MSBs of a and b are the same (both positive or both negative)
        // Perform absolute value addition
        res = (a[N-1] == 1'b0)? (a + b) : (-a + (-b)); // Add absolute values and set MSB accordingly
    end else begin // MSBs of a and b are different (one is positive, the other negative)
        // Perform absolute value subtraction
        if (a > b) begin
            res = a - b; // Result is a - b and MSB is 0 (positive)
        end else begin
            res = b - a; // Result is b - a and MSB is set according to whether the result is zero or negative
        end
    end

    // Manage overflow by observing the MSB
    if (res[N-1]!= a[N-1] && res[N-1]!= b[N-1]) begin
        // Overflow occurred, set result to maximum or minimum value
        res = (a[N-1] == 1'b0)? {N{1'b1}} : {N{1'b0}};
    end

    c = res; // Assign result to output
end

endmodule