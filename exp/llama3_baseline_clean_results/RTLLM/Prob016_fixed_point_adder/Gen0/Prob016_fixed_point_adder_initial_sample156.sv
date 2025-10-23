module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // MSBs are the same (both positive or both negative)
        // Absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin // Overflow
            res = (1 << N) - 1; // Set to maximum value
        end
    end else begin // MSBs are different (one is positive, the other negative)
        // Absolute value subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
        if (res < 0) begin // Result is negative
            res = -res; // Take the absolute value
            res[N-1] = 1; // Set the MSB to 1 (negative sign)
        end else begin
            res[N-1] = 0; // Set the MSB to 0 (positive sign)
        end
    end
end

assign c = res; // Assign the result to the output port

endmodule