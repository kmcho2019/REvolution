module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 0 // Initialize Q to 0 for predictable behavior
);

always @(posedge clk) begin
    if (j == 1'b1 && k == 1'b1) 
        Q <= ~Q; // Toggle when J and K are both 1
    else if (k == 1'b1) 
        Q <= 1'b0; // Reset when K is 1
    else if (j == 1'b1) 
        Q <= 1'b1; // Set when J is 1
    // else, no change (Q remains the same)
end

endmodule