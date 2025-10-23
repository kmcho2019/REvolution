module TopModule (
    input  wire clk,
    input  wire ar,
    input  wire d,
    output wire q
);

wire clk_buf;
wire master_out;

// Clock buffer for better signal integrity
buf clk_buffer(clk_buf, clk);

// Master latch (transparent when clock is low)
reg master_latch;
always @(ar or clk_buf or d) begin
    if (ar) begin
        master_latch <= 1'b0;
    end else if (~clk_buf) begin
        master_latch <= d;
    end
end

// Slave latch (transparent when clock is high)
reg slave_latch;
always @(ar or clk_buf or master_latch) begin
    if (ar) begin
        slave_latch <= 1'b0;
    end else if (clk_buf) begin
        slave_latch <= master_latch;
    end
end

assign q = slave_latch;

endmodule