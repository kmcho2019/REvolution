module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0=OFF, 1=ON
wire next_state;

assign next_state = areset ? 1'b0 : (state ? ~k : j);
assign out = state;

always @(posedge clk or posedge areset)
    state <= next_state;

endmodule