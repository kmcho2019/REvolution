module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire clk_n, master_out, slave_out;
wire reset_n, d_n;

// Inverters for clock and data
not(clk_n, clk);
not(d_n, d);

// Asynchronous reset logic
not(reset_n, ar);

// Master latch
wire nand1_out, nand2_out;
nand(nand1_out, clk, d, reset_n);
nand(nand2_out, clk, d_n, reset_n);
nand(master_out, nand1_out, nand2_out);

// Slave latch
wire nand3_out, nand4_out;
nand(nand3_out, clk_n, master_out);
nand(nand4_out, clk_n, ~master_out);
nand(slave_out, nand3_out, nand4_out);

// Output with reset override
assign q = ar ? 1'b0 : slave_out;

endmodule