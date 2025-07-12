module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Check if the MSBs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Add the absolute values and maintain the sign consistency
        res = (a[N-1] == 1'b0)? (a + b) : -(~(a + b) + 1'b1);
    end else begin
        // Compare the absolute values of a and b
        if (a[N-1] == 1'b1) begin
            // a is negative, b is positive
            if (a[N-1:Q] > b[N-1:Q]) begin
                // a has a larger absolute value
                res = -(~(b + (~a + 1'b1)) + 1'b1);
            end else begin
                // b has a larger absolute value
                res = b - (~a + 1'b1);
            end
        end else begin
            // a is positive, b is negative
            if (b[N-1:Q] > a[N-1:Q]) begin
                // b has a larger absolute value
                res = -(~(a + (~b + 1'b1)) + 1'b1);
            end else begin
                // a has a larger absolute value
                res = a - (~b + 1'b1);
            end
        end
    end

    // Assign the result to the output port
    c = res;
end

endmodule