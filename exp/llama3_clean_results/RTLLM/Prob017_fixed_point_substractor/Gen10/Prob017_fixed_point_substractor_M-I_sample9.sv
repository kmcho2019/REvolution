module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

always @(*) begin
    // Calculate the result using Verilog's built-in signed subtraction
    // This operation correctly handles signs and magnitudes
    c = a - b;
    
    // Explicitly handle the case where the result is zero
    if (c == 0) begin
        // Set the sign bit to 0 for a zero result
        c = {N{1'b0}};
    end
end

endmodule