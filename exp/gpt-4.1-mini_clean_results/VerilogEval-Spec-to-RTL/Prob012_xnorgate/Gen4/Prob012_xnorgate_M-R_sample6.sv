module TopModule (
    input  a,
    input  b,
    output reg out
);
    // Procedural XNOR implementation within an always_comb block
    // This style clearly separates combinational logic and can improve readability in some coding guidelines.
    always @* begin
        out = ~(a ^ b);
    end
endmodule