module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

wire next_state;
reg state;  // 0=OFF, 1=ON

assign next_state = areset ? 1'b0 : (state ? ~k : j);
assign out = state;

always @(posedge clk or posedge areset)
    state <= next_state;

endmodule