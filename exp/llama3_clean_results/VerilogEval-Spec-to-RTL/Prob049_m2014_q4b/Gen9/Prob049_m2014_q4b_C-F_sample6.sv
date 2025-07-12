module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar)
    if (ar) 
        q <= 1'b0; // Prioritize asynchronous reset
    else 
        q <= d;    // Update output on clock edge if not resetting

endmodule