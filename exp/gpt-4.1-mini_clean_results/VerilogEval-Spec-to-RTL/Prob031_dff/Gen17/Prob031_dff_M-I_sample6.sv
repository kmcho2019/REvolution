// TopModule implements a single positive edge-triggered D flip-flop
module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk)
        q <= d;
endmodule