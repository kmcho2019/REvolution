module TopModule (
    input  clk,         // Clock input
    input  d,           // Data input
    input  r,           // Synchronous reset (active high)
    output reg q = 1'b0  // Output register with default reset value
);

parameter RESET_VALUE = 1'b0;  // Configurable reset value

// Positive edge-triggered D flip-flop with synchronous reset
always @(posedge clk) begin
    if (r) begin
        q <= RESET_VALUE;  // Synchronous reset
    end
    else begin
        q <= d;            // Data capture
    end
end

endmodule