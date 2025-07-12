module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire clk_enable = (in != prev_in);  // Clock gating condition

    // Clock gating cell (integrated in modern libraries)
    wire gated_clk;
    CLKGATE clk_gate (.CLK(clk), .EN(clk_enable), .GCLK(gated_clk));

    always @(posedge gated_clk) begin
        anyedge <= in ^ prev_in;
        prev_in <= in;
    end

endmodule