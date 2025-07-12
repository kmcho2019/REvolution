module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out  // directly use reg for output
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Sequential state storage with async reset
always @(posedge clk or posedge areset)
    if (areset)         out <= OFF;
    else if (out == ON) out <= k ? OFF : ON;
    else                out <= j ? ON : OFF;

endmodule