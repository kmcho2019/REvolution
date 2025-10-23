module TopModule (
    input clk,    // Clock input
    input d,      // Data input
    input r,      // Synchronous reset (active high)
    output reg q  // Output register
);

// Positive edge-triggered behavior with synchronous reset
always @(posedge clk) begin
    if (r) begin  // Synchronous reset takes priority
        q <= 1'b0;
    end
    else begin   // Normal operation
        q <= d;
    end
end

endmodule