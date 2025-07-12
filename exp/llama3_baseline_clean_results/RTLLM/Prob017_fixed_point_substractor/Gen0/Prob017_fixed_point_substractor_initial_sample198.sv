module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

reg signed [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Calculate the result
    if ($signed(a[N-1]) == $signed(b[N-1])) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if ($signed(a) > $signed(b)) begin
            // Result is positive
            res = a - b;
        end else begin
            // Result is negative
            res = b - a;
        end
    end

    // Handle zero result
    if (res == 0) begin
        // Set sign bit to 0
        res[N-1] = 0;
    end

    // Assign result to output
    c = res;
end

endmodule