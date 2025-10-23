module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out
);

// Refactored version using an always block
always @(*)
begin
    // Direct implementation of the required logic within the always block
    if (a) begin
        out = 1'b1; // If a is 1, out is always 1
    end else begin
        // If a is 0, out is 1 if b is 0 and c is 1
        out = (~b & c);
    end
end

endmodule