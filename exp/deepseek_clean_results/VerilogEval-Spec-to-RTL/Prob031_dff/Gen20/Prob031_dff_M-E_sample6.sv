module TopModule(input clk, input d, output q);
    reg q_reg;
    wire update_enable;
    
    // Enable updates only when data changes during clock edge
    assign update_enable = (d != q_reg);
    assign q = q_reg;
    
    always @(posedge clk) begin
        if (update_enable) begin
            q_reg <= d;
        end
    end
endmodule