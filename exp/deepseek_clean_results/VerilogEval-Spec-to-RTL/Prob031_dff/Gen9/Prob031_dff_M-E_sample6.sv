module TopModule (
    input clk,
    input d,
    output reg q
);

// Master-slave implementation using latches
reg master_latch;

// Master latch (negative level-sensitive)
always @(clk or d) begin
    if (~clk) begin
        master_latch <= d;
    end
end

// Slave latch (positive level-sensitive)
always @(clk or master_latch) begin
    if (clk) begin
        q <= master_latch;
    end
end

endmodule