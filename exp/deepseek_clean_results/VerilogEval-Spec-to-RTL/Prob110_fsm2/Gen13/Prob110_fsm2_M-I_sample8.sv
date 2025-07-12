module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Explicit state encoding for better readability
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;  // Uses minimal 1-bit storage

always @(posedge clk or posedge areset)
    if (areset) 
        state <= OFF;
    else 
        state <= (state == ON) ? (k ? OFF : ON) : (j ? ON : OFF);

// Direct output assignment matches Moore machine property
assign out = state;

endmodule