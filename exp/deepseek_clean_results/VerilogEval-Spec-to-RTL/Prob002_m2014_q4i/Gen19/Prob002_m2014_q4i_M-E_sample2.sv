module TopModule(output out);
    reg out_reg;
    
    always @(posedge clk) begin
        out_reg <= 1'b0;
    end
    
    assign out = out_reg;
endmodule