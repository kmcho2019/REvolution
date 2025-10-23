module TopModule (
    input clk,
    input d,
    output reg q
);

    // Behavioral model of 2x clock generation
    wire clk_2x;
    reg toggle;
    
    initial toggle = 0;
    always @(posedge clk) toggle <= ~toggle;
    assign clk_2x = toggle;
    
    // Combined clock for double-edge sampling
    wire sample_clk = clk ^ clk_2x;
    
    // Single flip-flop sampling at double rate
    always @(posedge sample_clk) begin
        q <= d;
    end

endmodule