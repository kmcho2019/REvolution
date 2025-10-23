module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out;
wire slave_out;

// Master latch (active low clock)
assign master_out = ar ? 1'b0 : (~clk ? d : master_out);

// Slave latch (active high clock)
assign slave_out = ar ? 1'b0 : (clk ? master_out : slave_out);

assign q = slave_out;

endmodule