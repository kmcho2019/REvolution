module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine if the MSBs of a and b are the same (both positive or both negative)
    if (a[N-1] == b[N-1]) begin
        // Absolute Value Addition
        // Add the absolute values of a and b
        res = (a[N-1] == 1'b0) ? (a + b) : (-a + (-b));
    end else begin
        // Absolute Value Subtraction
        // Determine the larger absolute value
        if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // a is negative, b is positive
            res = (a < -b) ? (-a - b) : (b + a);
        end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            res = (a > -b) ? (a + b) : (-a - b);
        end
    end

    // Handle overflow
    if (res[N] == 1'b1) begin
        // Overflow occurred, saturate the result
        res = (res[N-1] == 1'b0) ? {N{1'b1}} : {N{1'b0}};
    end
end

assign c = res;

endmodule