module TopModule (
    input  clk,     // Clock input, positive edge triggered
    input  ar,      // Asynchronous active-high reset
    input  d,       // Data input
    output reg q    // Output register
);

// Positive edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar) 
        q <= 1'b0;   // Asynchronously reset q to 0 when ar is high
    else 
        q <= d;      // On clock edge, load input d into q
end

endmodule