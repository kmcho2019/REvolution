module TopModule (
    input clk,
    input d,
    output reg q
);

reg master_latch;  // Master latch storage
wire slave_enable = clk;  // Slave latch enable

// Master latch (active when clock is low)
always @(d or clk) begin
    if (~clk) begin
        master_latch <= d;
    end
end

// Slave latch (active when clock is high)
always @(master_latch or slave_enable) begin
    if (slave_enable) begin
        q <= master_latch;
    end
end

endmodule