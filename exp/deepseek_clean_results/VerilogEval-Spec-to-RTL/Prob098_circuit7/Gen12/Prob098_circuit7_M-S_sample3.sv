module TopModule(input clk, input a, output q);
    reg q_reg;
    
    assign q = q_reg;
    
    always @(posedge clk) begin
        q_reg <= ~a;
    end
endmodule