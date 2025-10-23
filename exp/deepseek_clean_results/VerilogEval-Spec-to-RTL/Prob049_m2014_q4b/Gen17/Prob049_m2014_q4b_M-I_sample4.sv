module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

// Technology-specific DFF with async reset
DFFARX1 dff_inst (
    .CLK(clk),
    .RST(ar),
    .D(d),
    .Q(q)
);

endmodule