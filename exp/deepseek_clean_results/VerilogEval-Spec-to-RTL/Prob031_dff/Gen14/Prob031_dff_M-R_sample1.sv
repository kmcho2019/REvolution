module TopModule(input clk, input d, output q);
    reg q_reg;
    
    // Clock-gated continuous assignment
    assign q = (clk && !$past(clk)) ? d : q_reg;
    
    // Update register on positive clock edge
    always @(posedge clk) begin
        q_reg <= d;
    end
endmodule