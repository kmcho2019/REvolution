module TopModule (
    input  wire clk,   // Clock input
    input  wire d,     // Data input
    input  wire r,     // Synchronous active-high reset
    output reg  q      // Output register
);

// Synchronous reset D flip-flop implementation
always @(posedge clk) begin
    if (r)           // If reset is asserted
        q <= 1'b0;   // Reset output to zero synchronously
    else
        q <= d;      // Otherwise, capture data input
end

endmodule