module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits (for documentation clarity, not directly used in this implementation)
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Using always block for combinational logic (though assign is more typical for such cases)
always @(*) begin
    // Perform subtraction directly
    // The built-in signed arithmetic in Verilog handles signs and magnitudes correctly.
    c = a - b;
end

endmodule