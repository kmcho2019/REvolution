module TopModule(input clk, input d, output reg q);
    wire clk_enable;
    wire gated_clk;
    
    // Detect input changes
    assign clk_enable = (d != q);
    
    // Create gated clock
    assign gated_clk = clk & clk_enable;
    
    // Main flip-flop
    always @(posedge gated_clk) begin
        q <= d;
    end
endmodule