module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Clock gating: enable clock only when slowena is high or reset active
wire gated_clk = (slowena | reset) ? clk : 1'b0;

always @(posedge gated_clk) begin
    if (reset)
        q <= 4'd0;
    else if (slowena)
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
end

endmodule