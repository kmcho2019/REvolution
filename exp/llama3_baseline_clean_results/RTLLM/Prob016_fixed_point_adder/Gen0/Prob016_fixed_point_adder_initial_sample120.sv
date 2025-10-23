module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

// Internal register to store the result
reg [N-1:0] res;

// Determine the sign bits of the input operands
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Perform addition or subtraction based on the signs
always @(*) begin
    if (a_sign == b_sign) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1:Q] > b[N-1:Q]) begin
            // a is greater than b
            res = a - b;
        end else begin
            // b is greater than a
            res = b - a;
            // Set the MSB of the result if the result is negative
            if (res[N-1:Q] < 0) begin
                res[N-1] = 1'b1;
            end else begin
                res[N-1] = 1'b0;
            end
        end
    end
    // Set the MSB of the result to match the MSBs of a and b
    if (a_sign == b_sign) begin
        res[N-1] = a_sign;
    end
    // Assign the result to the output
    c <= res;
end

endmodule