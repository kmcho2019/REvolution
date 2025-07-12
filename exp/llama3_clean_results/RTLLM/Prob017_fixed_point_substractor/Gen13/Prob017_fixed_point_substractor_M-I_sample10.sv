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
        c = 0; // Ensure sign bit is 0 for zero result
    end
end

endmodule