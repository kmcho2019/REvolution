module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire cd_or;

    // Compute OR of inputs c and d once
    assign cd_or = c | d;

    // q is asserted when either a or b is high AND either c or d is high
    // Factored to share the (c|d) term for potential power and area benefits
    assign q = (a & cd_or) | (b & cd_or);

endmodule