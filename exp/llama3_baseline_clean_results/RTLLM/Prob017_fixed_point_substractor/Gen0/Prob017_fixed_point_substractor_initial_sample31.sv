module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the sign of the inputs
    if (a[N-1] == 0 && b[N-1] == 0) begin // Both positive
        // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 1 && b[N-1] == 1) begin // Both negative
        // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 0 && b[N-1] == 1) begin // a positive, b negative
        // Different sign subtraction (addition)
        res = a + (~b + 1); // Two's complement of b
    end else if (a[N-1] == 1 && b[N-1] == 0) begin // a negative, b positive
        // Different sign subtraction (addition)
        res = (~a + 1) + b; // Two's complement of a
    end

    // Handle zero result
    if (res == 0) begin
        res = 0; // Explicitly set sign bit to 0
    end

    // Assign the result to the output
    c = res;
end

endmodule