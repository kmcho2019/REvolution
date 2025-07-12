module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Clock gating enable signal
wire clk_en = slowena | reset;

// Gated clock generation (simple latch-based gating for illustration)
reg gated_clk;
reg clk_en_d;

always @(posedge clk) begin
    clk_en_d <= clk_en;
    gated_clk <= clk_en & clk & ~clk_en_d;
end

always @(posedge gated_clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
end

endmodule