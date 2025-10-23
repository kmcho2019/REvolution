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
    
    // Explicitly handle the case when the result is zero to ensure the sign bit is correct
    if (c == 0) begin
        // Setting the sign bit to 0 for a zero result is not necessary in signed arithmetic
        // but we ensure the output is explicitly set to 0 for clarity
        c = 32'd0;
    end
end

endmodule