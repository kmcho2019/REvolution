module TopModule(
    input clk,
    input d,
    output q
);

FD u_dff (
    .C(clk),  // Clock
    .D(d),    // Data input
    .Q(q)     // Data output
);

endmodule