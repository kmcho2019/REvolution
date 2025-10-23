module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0=OFF, 1=ON

always @(posedge clk or posedge areset)
    if (areset) state <= 1'b0;
    else state <= state ? ~k : j;

assign out = state;

endmodule