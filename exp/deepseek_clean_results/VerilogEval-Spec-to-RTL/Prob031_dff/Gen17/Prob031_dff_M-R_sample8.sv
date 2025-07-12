module TopModule(input clk, input d, output q);
    reg q_reg;
    wire clk_rise = clk & ~$past(clk);
    
    assign q = q_reg;
    assign q_reg = clk_rise ? d : q_reg;
endmodule