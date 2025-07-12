module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

// Clock gating enable signal: enable flip-flop update only when reset asserted or d != q
wire enable = r | (d != q);

reg gated_clk;
always @(posedge clk or posedge r) begin
    if (r)
        q <= 1'b0;
    else if (enable)
        q <= d;
end

endmodule