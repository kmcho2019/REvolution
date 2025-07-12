module TopModule(input clk, input d, output q);
    wire master_out;
    
    // Master latch (active low)
    assign master_out = ~clk ? d : master_out;
    
    // Slave latch (active high)
    assign q = clk ? master_out : q;
endmodule