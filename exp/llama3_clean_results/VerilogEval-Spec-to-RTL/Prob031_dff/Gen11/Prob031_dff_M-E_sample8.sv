module TopModule(
    input clk,
    input d,
    output reg q
);

reg master_q;

always_latch
if (clk) master_q = d;

always_latch
if (!clk) q = master_q;

endmodule