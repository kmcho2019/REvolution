module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar)
    if (ar) 
        q <= 1'b0; // Explicitly reset to 0 for clarity
    else 
        q <= d;    // Use non-blocking assignment for sequential logic

endmodule