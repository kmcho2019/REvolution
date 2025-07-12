module TopModule (
    input clk,
    input d,
    output q
);

wire clk_n, master_out, slave_out;
wire d_n, s_n, r_n;

// Clock inversion
not(clk_n, clk);

// Master latch (negative level-sensitive)
nand(s_n, d, clk);
nand(r_n, ~d, clk);
nand(master_out, s_n, slave_out);
nand(slave_out, r_n, master_out);

// Slave latch (positive level-sensitive)
wire s_slave, r_slave;
nand(s_slave, master_out, clk_n);
nand(r_slave, ~master_out, clk_n);
nand(q, s_slave, q_bar);
nand(q_bar, r_slave, q);

endmodule