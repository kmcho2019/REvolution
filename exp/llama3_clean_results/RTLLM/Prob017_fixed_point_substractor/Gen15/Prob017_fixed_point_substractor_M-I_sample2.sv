module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

always @(*) begin
    // Perform subtraction directly, relying on Verilog's handling of signed numbers
    c = a - b;
    
    // Explicitly handle edge cases for consistency
    if (c == 0) begin
        // Ensure the sign bit is correct for a zero result
        c = 32'd0;
    end else if (c[N-1] == 1'b1 && (a[N-1] == 1'b0 || b[N-1] == 1'b0)) begin
        // Handle cases where the result's sign differs from both inputs
        // This is implicitly handled by Verilog's signed arithmetic, but explicit handling can improve clarity
        c = c;
    end
end

endmodule