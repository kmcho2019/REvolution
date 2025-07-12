module TopModule (
    // Clock and Reset
    input  clk,
    input  ar,    // Asynchronous reset (active high)
    
    // Data signals
    input  d,     // Data input
    
    // Output
    output reg q  // Data output
);

// Positive edge-triggered DFF with async reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;  // Async reset
    end
    else begin
        q <= d;     // Data capture on rising clock edge
    end
end

endmodule