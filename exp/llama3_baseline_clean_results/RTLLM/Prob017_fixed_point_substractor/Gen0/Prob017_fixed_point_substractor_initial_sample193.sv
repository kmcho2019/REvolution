module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
        // Handle overflow (if result goes beyond N bits), but since we're doing subtraction,
        // the result should fit within N bits if a and b are correctly represented.
    end else begin // Different signs
        if (a[N-1] == 0) begin // a is positive, b is negative
            res = a + (~b + 1); // Two's complement of b and then add
        end else begin // a is negative, b is positive
            res = (~a + 1) + b; // Two's complement of a and then add
        end
        // In different sign cases, if the result is zero, explicitly set the sign bit to 0.
        if (res == 0) begin
            res = {1'b0, {N-1{1'b0}}}; // Set sign bit to 0, rest to 0s (though rest should be 0s naturally for res == 0)
        end
    end
    // Explicitly handling zero to ensure sign bit is correct
    if (res == 0) begin
        res[N-1] = 1'b0; // Ensure sign bit is 0 for zero result
    end
end

assign c = res;

endmodule