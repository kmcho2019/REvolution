module TopModule(input clk, input d, output q);
    wire clk_n = ~clk;
    wire master_out;
    
    // Master latch (transparent when clk is low)
    always @(clk_n or d) begin
        if (!clk_n) master_out <= d;
    end
    
    // Slave latch (transparent when clk is high)
    always @(clk or master_out) begin
        if (clk) q <= master_out;
    end
endmodule