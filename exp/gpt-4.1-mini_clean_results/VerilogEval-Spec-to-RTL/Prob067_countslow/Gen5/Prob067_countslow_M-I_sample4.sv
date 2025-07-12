module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Generate gated clock: clk_en is high only when slowena is high and reset is low
wire clk_en = slowena && ~reset;
reg gated_clk;
reg clk_en_d;

// Synchronize clock enable to avoid glitches on gated_clk
always @(posedge clk) begin
    clk_en_d <= clk_en;
    gated_clk <= clk_en_d & clk;
end

always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        if (q == 4'd9)
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
end

endmodule