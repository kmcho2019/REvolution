module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

// Explicitly define the asynchronous reset condition
always @(posedge clk or posedge ar)
    if (ar) 
        // Asynchronous reset takes precedence
        q <= 1'b0;
    else if (posedge clk) 
        // Positive edge of the clock triggers the D flip-flop
        q <= d;

endmodule