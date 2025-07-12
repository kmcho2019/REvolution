module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out, slave_out;
wire clk_n = ~clk;

// Master latch with transmission gate and async reset
assign master_out = ar ? 1'b0 : (clk ? d : master_out);

// Slave latch with transmission gate and async reset
assign slave_out = ar ? 1'b0 : (clk_n ? master_out : slave_out);

// Output buffer
assign q = slave_out;

endmodule