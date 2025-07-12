module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out;
reg slave_out;

// Master latch (active low clock)
assign master_out = (~clk & ~ar) ? d : (ar ? 1'b0 : master_out);

// Slave latch (active high clock)
always @(*)
    if (ar)
        slave_out = 1'b0;
    else if (clk)
        slave_out = master_out;

assign q = slave_out;

endmodule