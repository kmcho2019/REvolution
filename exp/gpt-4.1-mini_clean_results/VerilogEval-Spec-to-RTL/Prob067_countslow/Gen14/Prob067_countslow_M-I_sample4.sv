module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Clock gating enable signal: active when reset or slowena is asserted
wire clk_en = slowena | reset;

// Simple clock gating latch
reg gated_clk_en_d;
always @(posedge clk) gated_clk_en_d <= clk_en;
wire gated_clk = gated_clk_en_d & clk;

// Counter logic triggered on gated clock
always @(posedge gated_clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
end

endmodule