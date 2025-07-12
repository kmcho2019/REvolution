module TopModule(
    input clk,
    input a,
    output reg q
);

// This module implements a simple sequential circuit that inverts the input 'a' and assigns it to the output 'q' on the positive edge of the clock 'clk'.
always @(posedge clk) 
    q <= ~a;

endmodule