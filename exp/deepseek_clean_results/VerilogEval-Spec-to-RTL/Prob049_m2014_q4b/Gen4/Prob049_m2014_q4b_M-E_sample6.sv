module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out;
reg slave_out;

// Master latch (active low clock)
always @(clk or ar or d) begin
    if (ar) begin
        master_out <= 1'b0;
    end else if (~clk) begin
        master_out <= d;
    end
end

// Slave latch (active high clock)
always @(clk or ar or master_out) begin
    if (ar) begin
        slave_out <= 1'b0;
    end else if (clk) begin
        slave_out <= master_out;
    end
end

assign q = slave_out;

endmodule