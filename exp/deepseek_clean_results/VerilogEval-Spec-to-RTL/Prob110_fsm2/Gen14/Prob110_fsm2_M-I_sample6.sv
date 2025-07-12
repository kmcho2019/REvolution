module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;  // OFF or ON

always @(posedge clk or posedge areset)
    if (areset) state <= OFF;
    else state <= state ? ~k : j;

assign out = state;

endmodule