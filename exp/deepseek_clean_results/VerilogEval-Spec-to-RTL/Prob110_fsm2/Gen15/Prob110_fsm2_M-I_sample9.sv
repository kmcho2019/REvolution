module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;

// Combined state register and next state logic
always @(posedge clk or posedge areset)
    if (areset)
        state <= OFF;
    else
        state <= (state == ON) ? (k ? OFF : ON) : (j ? ON : OFF);

// Direct output assignment
assign out = state;

endmodule