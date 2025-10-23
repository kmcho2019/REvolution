module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out;
wire slave_in;

// Master latch (active when clk is low)
assign master_out = ar ? 1'b0 : (~clk ? d : master_out);

// Slave latch (active when clk is high)
assign slave_in = ar ? 1'b0 : (clk ? master_out : slave_in);

// Output assignment
assign q = slave_in;

endmodule