`default_nettype none

module TopModule(
    input wire clk,
    input wire d,
    output wire q
);
    // Clock buffer for better clock distribution
    wire clk_buf;
    assign clk_buf = clk;
    
    // Master-slave implementation using latches
    reg master_latch;
    reg slave_latch;
    
    // Master latch (transparent when clock is low)
    always @(clk_buf or d) begin
        if (~clk_buf) begin
            master_latch <= d;
        end
    end
    
    // Slave latch (transparent when clock is high)
    always @(clk_buf or master_latch) begin
        if (clk_buf) begin
            slave_latch <= master_latch;
        end
    end
    
    // Output assignment
    assign q = slave_latch;
    
    // Simulation initialization
    initial begin
        master_latch = 1'b0;
        slave_latch = 1'b0;
    end
endmodule

`default_nettype wire