module TopModule(input clk, input d, output q);
    wire master_out;
    wire clk_n = ~clk;  // Internal clock inversion
    
    // Master latch (transparent when clock is low)
    always @(clk or d)
        if (~clk) master_out <= d;
    
    // Slave latch (transparent when clock is high)
    always @(clk or master_out)
        if (clk) q <= master_out;
endmodule