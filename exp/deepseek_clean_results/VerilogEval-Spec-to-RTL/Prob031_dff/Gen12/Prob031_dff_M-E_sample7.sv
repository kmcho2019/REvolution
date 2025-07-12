module TopModule(input clk, input d, output q);
    // Internal signals
    wire gated_clk;
    reg last_d;
    
    // Clock gating logic - only allow clock when input changes
    assign gated_clk = clk & (d ^ last_d);
    
    // Track last input value for gating
    always @(posedge clk) begin
        last_d <= d;
    end
    
    // Custom DFF with async reset (tied to 0)
    reg q_reg = 1'b0;
    always @(posedge gated_clk or posedge 1'b0) begin
        if (1'b0) q_reg <= 1'b0;  // Async reset (disabled)
        else q_reg <= d;
    end
    
    assign q = q_reg;
endmodule