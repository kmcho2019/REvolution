module TopModule (
    input clk,
    input d,
    output q
);

wire master_out;
reg slave_out;

// Master latch (active when clk is low)
always @(clk or d) begin
    if (~clk) begin
        master_out <= d;
    end
end

// Slave latch (active when clk is high)
always @(clk or master_out) begin
    if (clk) begin
        slave_out <= master_out;
    end
end

assign q = slave_out;

endmodule