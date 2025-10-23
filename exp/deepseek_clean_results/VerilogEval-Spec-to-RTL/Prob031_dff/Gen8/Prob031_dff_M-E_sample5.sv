module TopModule (
    input clk,
    input d,
    output reg q
);

// Internal signals for master-slave configuration
wire master_out;

// Master latch (active when clock is low)
always @(clk or d) begin
    if (~clk) begin
        master_out <= d;
    end
end

// Slave latch (active when clock is high)
always @(clk or master_out) begin
    if (clk) begin
        q <= master_out;
    end
end

endmodule