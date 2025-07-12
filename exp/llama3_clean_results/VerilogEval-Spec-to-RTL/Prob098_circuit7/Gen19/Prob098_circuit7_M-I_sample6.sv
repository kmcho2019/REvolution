module TopModule(
    input clk,
    input a,
    output reg q
);

// Initial state
initial q = 1'b1;

// State transition logic and output q based on current state
always @(posedge clk) 
    q <= ~a;

endmodule