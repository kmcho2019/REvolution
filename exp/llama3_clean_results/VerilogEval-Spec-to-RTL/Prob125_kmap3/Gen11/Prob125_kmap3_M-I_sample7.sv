module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out
);

// Combinational always block for calculating output
always @(*) begin
    // Use bitwise operators for efficiency
    out = a | (~a & ~b & c);
end

endmodule