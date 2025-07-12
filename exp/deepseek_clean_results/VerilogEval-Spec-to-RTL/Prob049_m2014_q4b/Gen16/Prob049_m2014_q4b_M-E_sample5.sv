module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);

wire master_out, slave_out;
wire clk_n, d_n;
wire master_reset, slave_reset;

// Inverters for clock and data
not (clk_n, clk);
not (d_n, d);

// Reset signals for master and slave
nor (master_reset, ar, clk);
nor (slave_reset, ar, clk_n);

// Master stage (negative level-sensitive)
wire master_nand1_out, master_nand2_out;
nand (master_nand1_out, master_reset, d, clk);
nand (master_nand2_out, master_reset, master_nand1_out, d_n);
nand (master_out, master_nand1_out, master_nand2_out);

// Slave stage (positive level-sensitive)
wire slave_nand1_out, slave_nand2_out;
nand (slave_nand1_out, slave_reset, master_out, clk_n);
nand (slave_nand2_out, slave_reset, slave_nand1_out, master_out);
nand (slave_out, slave_nand1_out, slave_nand2_out);

// Output assignment
assign q = slave_out;

endmodule