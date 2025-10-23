module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire ab_xnor;
    wire cd_xnor;

    // XNOR pairs of inputs
    assign ab_xnor = ~(a ^ b);
    assign cd_xnor = ~(c ^ d);

    // Multiplexer selects between ab_xnor and cd_xnor based on c
    assign out = c ? ab_xnor : cd_xnor;
endmodule