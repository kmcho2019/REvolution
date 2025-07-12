module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize q to 1 (since it becomes 1 when a is 0 at the first clock edge)
initial q = 1'b1;

// State transition logic and output q based on current state
always @(posedge clk) 
    if (a) // If a is 1, set q to 0 at the next clock edge
        q <= 1'b0;
    else // If a is 0, keep q as 1
        q <= 1'b1;

endmodule