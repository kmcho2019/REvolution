module TopModule(input clk, input d, output q);
    wire d_changed, gated_clk;
    reg d_prev;
    
    // Detect input changes
    always @(posedge clk) begin
        d_prev <= d;
    end
    
    assign d_changed = d ^ d_prev;
    assign gated_clk = clk & d_changed;
    
    // Main flip-flop
    reg q_reg;
    always @(posedge gated_clk) begin
        q_reg <= d;
    end
    
    assign q = q_reg;
endmodule