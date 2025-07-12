module TopModule (
    input clk,
    input d,
    output q
);

// Instantiate technology-specific D flip-flop primitive
DFF dff_inst (
    .CLK(clk),
    .D(d),
    .Q(q)
);

endmodule