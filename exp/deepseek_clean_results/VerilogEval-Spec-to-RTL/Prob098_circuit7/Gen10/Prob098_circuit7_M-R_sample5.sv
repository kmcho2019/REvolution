module TopModule(input clk, input a, output q);
    wire a_inv = ~a;
    reg q_reg;
    
    assign q = q_reg;
    
    always @(posedge clk) begin
        q_reg <= a_inv;
    end
endmodule