module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Explicit initialization of q for clarity
);

// Detailed comment explaining the purpose of the always block
// This always block updates the output q with the inverse of input a at each positive clock edge when a is 1
always @(posedge clk) 
    if (a) 
        // Use of non-blocking assignment to ensure proper scheduling of q update
        q <= ~q; // Concise assignment of the inverse of q to q when a is 1

endmodule