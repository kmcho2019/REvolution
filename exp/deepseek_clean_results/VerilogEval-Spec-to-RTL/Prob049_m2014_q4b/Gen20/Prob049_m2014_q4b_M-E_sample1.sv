module TopModule (
    input  wire clk,
    input  wire ar,
    input  wire d,
    output wire q
);

wire master_out;  // Output of master latch
wire slave_in;    // Input to slave latch
wire clk_n;       // Inverted clock

// Inverted clock for master latch
assign clk_n = ~clk;

// Master latch (transparent when clock is low)
assign master_out = (clk_n) ? (ar ? 1'b0 : d) : master_out;

// Slave latch input (reset overrides normal path)
assign slave_in = ar ? 1'b0 : master_out;

// Slave latch (transparent when clock is high)
reg slave_out;
always @(*) begin
    if (clk) slave_out = slave_in;
end

assign q = slave_out;

endmodule