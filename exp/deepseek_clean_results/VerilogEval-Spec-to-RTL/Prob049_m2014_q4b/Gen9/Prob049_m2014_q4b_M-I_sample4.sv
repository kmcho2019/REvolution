module TopModule (
    input  wire clk,  // Clock input
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Data output
);

// Positive edge-triggered D flip-flop with async reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;    // Async reset has priority
    end else begin
        q <= d;       // Normal operation
    end
end

endmodule