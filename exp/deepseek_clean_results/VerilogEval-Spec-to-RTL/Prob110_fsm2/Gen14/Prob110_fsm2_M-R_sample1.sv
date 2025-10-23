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
wire next_state;

// Next state logic using continuous assignment
assign next_state = (state == ON) ? (k ? OFF : ON) : (j ? ON : OFF);

// State register update
always @(posedge clk or posedge areset)
    if (areset)
        state <= OFF;
    else
        state <= next_state;

// Output assignment
assign out = state;

endmodule