module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // 'd' is don't-care, not used in the logic
    output reg out
);

// Refactored implementation using an always block for combinational logic
always @(*) begin
    // Compute out using bitwise OR and negation, same logic as before
    out = (a | (!a & ~b & c));
end

// This refactored version maintains the same functionality as the original
// but demonstrates an alternative structure using an always block

endmodule