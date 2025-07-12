module TopModule(input clk, input d, output reg q);
    reg last_d;
    wire clk_en;
    wire gated_clk;
    
    // Detect input changes
    assign clk_en = d ^ last_d;
    
    // Simple clock gating (in real designs use proper clock gating cells)
    assign gated_clk = clk & clk_en;
    
    always @(posedge gated_clk) begin
        q <= d;
        last_d <= d;  // Store previous input
    end
endmodule