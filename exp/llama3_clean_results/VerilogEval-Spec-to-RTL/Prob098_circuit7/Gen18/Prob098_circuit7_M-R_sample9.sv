module TopModule(
    input clk,
    input a,
    output reg q
);

// Use a D flip-flop to store the output q
always @(posedge clk) 
    q <= ~a;

endmodule