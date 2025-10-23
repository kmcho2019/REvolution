module TopModule(input clk, input a, output q);
    wire d;
    reg q_reg;
    
    // Combinational logic
    assign d = ~a;
    
    // Sequential element
    always @(posedge clk) begin
        q_reg <= d;
    end
    
    assign q = q_reg;
endmodule