module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);

wire clk_n, d_n;
wire master_out, slave_out;
wire reset_n;

// Inverters for clock and data
not (clk_n, clk);
not (d_n, d);
not (reset_n, ar);

// Master stage (negative level-sensitive)
wire master_nand1_out, master_nand2_out;
nand (master_nand1_out, d, clk, reset_n);
nand (master_nand2_out, d_n, clk, reset_n);
nand (master_out, master_nand1_out, master_nand2_out);

// Slave stage (positive level-sensitive)
wire slave_nand1_out, slave_nand2_out;
nand (slave_nand1_out, master_out, clk_n, reset_n);
nand (slave_nand2_out, master_out, clk_n, reset_n);
nand (slave_out, slave_nand1_out, slave_nand2_out);

// Output stage with reset
wire q_n;
nand (q, slave_out, reset_n);
nand (q_n, q, reset_n);

endmodule