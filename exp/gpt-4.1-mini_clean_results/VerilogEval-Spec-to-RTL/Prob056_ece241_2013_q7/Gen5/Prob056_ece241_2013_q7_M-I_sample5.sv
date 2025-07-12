module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire toggle;
wire nextQ_non_toggle;

assign toggle = j & k;              // when J=K=1, toggle Q
assign nextQ_non_toggle = (j & ~k) | (Q & ~j & ~k); 
// nextQ when not toggling: if J=1,K=0 Q=1; if J=0,K=1 Q=0; if J=0,K=0 hold Q
// simplified as (j & ~k) | (Q & ~j & ~k)

always @(posedge clk) begin
    if (toggle)
        Q <= ~Q;
    else
        Q <= nextQ_non_toggle;
end

endmodule