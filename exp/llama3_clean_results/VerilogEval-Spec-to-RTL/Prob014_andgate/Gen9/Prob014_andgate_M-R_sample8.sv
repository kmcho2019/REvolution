module TopModule(
    input  a,
    input  b,
    output reg out
);
// Refactored implementation using an always block.
always @(*) begin
    // Perform the AND operation and assign the result to out.
    out = a & b;
end

endmodule