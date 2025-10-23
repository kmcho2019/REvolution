module TopModule(input clk, input a, output q);
    reg a_reg;
    wire a_inv;
    
    assign a_inv = ~a;
    assign q = a_reg;
    
    always @(posedge clk) begin
        a_reg <= a_inv;
    end
endmodule