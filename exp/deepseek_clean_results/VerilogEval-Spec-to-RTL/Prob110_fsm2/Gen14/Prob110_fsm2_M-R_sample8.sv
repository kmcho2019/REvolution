module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0=OFF, 1=ON

wire next_state = state ? ~k : j;

always @(posedge clk or posedge areset)
    if (areset) state <= 0;
    else state <= next_state;

assign out = state;

endmodule