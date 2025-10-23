module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // MSBs of a and b are the same
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (b[N-1] == 0) begin  // b is positive
                // Determine larger absolute value and perform subtraction
                if (a < b) begin
                    res = b - (a >>> Q) + (a[N-1] ? 1 : 0);
                    res[N-1] = 0;  // Set MSB of result to 0 (positive)
                end else begin
                    res = (a >>> Q) - b;
                    if (res == 0) begin
                        res = 0;
                    end else begin
                        res[N-1] = 1;  // Set MSB of result to 1 (negative)
                    end
                end
            end
        end else begin  // a is positive
            if (b[N-1] == 1) begin  // b is negative
                // Determine larger absolute value and perform subtraction
                if (b < a) begin
                    res = a - (b >>> Q) + (b[N-1] ? 1 : 0);
                    res[N-1] = 0;  // Set MSB of result to 0 (positive)
                end else begin
                    res = (b >>> Q) - a;
                    if (res == 0) begin
                        res = 0;
                    end else begin
                        res[N-1] = 1;  // Set MSB of result to 1 (negative)
                    end
                end
            end
        end
    end
end

assign c = res;  // Assign the result to output port c

endmodule