module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits (for documentation clarity, not directly used in this implementation)
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Perform subtraction using an always block for more control over the logic
always @(*) begin
    // Direct subtraction, letting Verilog handle the signs and magnitudes
    c = a - b;
    
    // Explicitly handle the zero result case, if necessary
    if (c == 0) begin
        // Ensure the sign bit is set to 0 for a zero result
        c = 0;
    end
end

endmodule