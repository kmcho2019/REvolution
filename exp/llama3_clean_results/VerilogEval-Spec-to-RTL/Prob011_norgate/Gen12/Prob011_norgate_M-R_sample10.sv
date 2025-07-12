// Module TopModule: a simple NOR gate implementation using always block.
module TopModule(
    input  a,
    input  b,
    output out
);
// Perform NOR operation: out is 1 only if both a and b are 0.
always @(*) begin
    out = ~(a | b); // NOR operation
end

endmodule