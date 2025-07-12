module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Shared intermediate wire to factor common sub-expression (c | d)
    wire cd_or;
    assign cd_or = c | d;

    // Output q is high when either a or b is high AND either c or d is high.
    // Factoring (c | d) reduces duplicated logic, which may improve power and area.
    assign q = (a & cd_or) | (b & cd_or);

endmodule