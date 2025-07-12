module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out;
wire slave_out;

// Master latch (active low clock)
assign master_out = (~clk & ~ar) ? d : 
                    (ar) ? 1'b0 : master_out;

// Slave latch (active high clock)
assign slave_out = (clk & ~ar) ? master_out : 
                   (ar) ? 1'b0 : slave_out;

assign q = slave_out;

endmodule