module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize q to 1 (high state)
initial q = 1'b1;

// Update q based on input a and current state
always @(posedge clk) 
    q <= ~a ? q : ~q;

endmodule