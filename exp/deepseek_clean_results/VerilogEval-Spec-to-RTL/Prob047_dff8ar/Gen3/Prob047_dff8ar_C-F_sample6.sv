module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// 8-bit register with async reset
// Resets to 0 on areset, otherwise captures input on rising clock edge
always @(posedge clk or posedge areset)
    if (areset) q <= 8'b0;
    else q <= d;

endmodule