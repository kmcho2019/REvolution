module TopModule (
    input clk,
    input d,
    output q
);

wire master_out;
wire clk_n = ~clk;

// Master latch (negative level-sensitive)
LATCH master (
    .d(d),
    .en(clk_n),
    .q(master_out)
);

// Slave latch (positive level-sensitive)
LATCH slave (
    .d(master_out),
    .en(clk),
    .q(q)
);

endmodule

module LATCH (
    input d,
    input en,
    output reg q
);
always @*
    if (en) q = d;
endmodule