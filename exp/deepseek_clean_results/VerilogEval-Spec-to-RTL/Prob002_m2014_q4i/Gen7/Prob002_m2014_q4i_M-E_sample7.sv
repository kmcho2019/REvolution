module TopModule(output out);
    reg out_reg;
    
    initial begin
        out_reg = 0;
    end
    
    assign out = out_reg;
endmodule