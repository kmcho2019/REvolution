module TopModule(input clk, input a, output q);
    reg q_reg = 1'b1;  // Initialize to 1
    
    assign q = q_reg;
    
    always @(posedge clk) begin
        if (a) q_reg <= 1'b0;
    end
endmodule