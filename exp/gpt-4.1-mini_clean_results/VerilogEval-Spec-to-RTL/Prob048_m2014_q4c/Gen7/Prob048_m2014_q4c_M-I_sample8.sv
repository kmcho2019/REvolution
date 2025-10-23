module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

// Clock gating signal: enable clock only when reset asserted or data differs from current q
wire clk_en = r | (d != q);

// Gated clock
wire gated_clk = clk & clk_en;

always @(posedge gated_clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= d;
end

endmodule