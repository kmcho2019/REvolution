module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0=OFF, 1=ON

// Combined sequential logic with direct state transition
always @(posedge clk or posedge areset)
    if (areset) state <= 0;
    else state <= state ? ~k : j;

// Output assignment
assign out = state;

endmodule