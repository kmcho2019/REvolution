module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

always @(*) begin
    // Direct subtraction handles sign logic inherently
    c = a - b;
    
    // Explicitly handle the case where the result is zero
    if (c == 0) begin
        // Ensure the sign bit is set to 0 for a zero result
        c = 0;
    end
end

endmodule