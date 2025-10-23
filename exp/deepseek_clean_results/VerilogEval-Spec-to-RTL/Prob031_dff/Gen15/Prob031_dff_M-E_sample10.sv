module TopModule(input clk, input d, output q);
    wire master_out;
    
    // Master latch (negative level)
    always @(clk or d) begin
        if (~clk)
            master_out = d;
    end
    
    // Slave latch (positive level)
    always @(clk or master_out) begin
        if (clk)
            q = master_out;
    end
endmodule