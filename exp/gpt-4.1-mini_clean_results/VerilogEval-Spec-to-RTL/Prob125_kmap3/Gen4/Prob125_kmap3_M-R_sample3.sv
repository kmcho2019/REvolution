module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,  // don't-care, not used in logic
    output reg  out
);

always @(*) begin
    // Compute intermediate signals
    wire term1 = c & (a | ~b);
    wire term2 = a & ~c;

    out = term1 | term2;
end

endmodule