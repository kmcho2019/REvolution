module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

// Perform subtraction based on the signs of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
            res = a + (~b + 1'b1); // Add the two's complement of b to a
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a is negative, b is positive
            res = (~a + 1'b1) + b; // Add the two's complement of a to b
        end
    end

    // Explicitly handle the case where the result is zero
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}}; // Set the sign bit to 0 for zero result
    end else begin
        c = res; // Assign the calculated result to the output
    end
end

endmodule