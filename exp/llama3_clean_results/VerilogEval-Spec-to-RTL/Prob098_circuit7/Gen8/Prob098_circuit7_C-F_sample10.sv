module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Explicit initialization of q for clarity
);

// Detailed comment explaining the purpose of the always block
// This always block updates the output q with the inverse of input a at each positive clock edge
always @(posedge clk) 
    // Use of non-blocking assignment to ensure proper scheduling of q update
    q <= ~a; // Concise assignment of the inverse of a to q

endmodule