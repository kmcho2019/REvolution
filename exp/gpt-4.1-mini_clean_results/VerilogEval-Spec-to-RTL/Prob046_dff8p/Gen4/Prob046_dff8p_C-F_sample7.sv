module TopModule (
    input        clk,    // Clock input, negative edge triggered
    input        reset,  // Active high synchronous reset
    input  [7:0] d,      // Data input
    output reg [7:0] q   // Data output (register content)
);

    // On negative edge of clock, update q
    // If reset is asserted, load constant 0x34 instead of zero
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;  // Synchronous reset to 0x34
        else
            q <= d;      // Normal operation: latch input d
    end

endmodule