module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Initialize q to 1
);

// Update q with the inverse of a at each positive clock edge
always @(posedge clk) 
    q <= ~a; // Use non-blocking assignment to ensure proper scheduling of q update

endmodule