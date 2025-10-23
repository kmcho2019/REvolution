module TopModule (
    input clk,
    input d,
    output q
);

reg master_latch;
reg slave_latch;

// Master latch (active when clk is low)
always @(d or clk) begin
    if (~clk)
        master_latch <= d;
end

// Slave latch (active when clk is high)
always @(master_latch or clk) begin
    if (clk)
        slave_latch <= master_latch;
end

assign q = slave_latch;

endmodule