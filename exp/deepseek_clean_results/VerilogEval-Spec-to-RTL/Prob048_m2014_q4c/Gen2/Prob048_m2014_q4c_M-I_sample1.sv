module TopModule (
    // Clock and Reset
    input  clk,
    input  r,    // Active high synchronous reset
    
    // Data signals
    input  d,    // Data input
    output reg q // Data output
);

// Positive edge-triggered D flip-flop with synchronous reset
always @(posedge clk) begin
    if (r == 1'b1) begin  // Synchronous reset
        q <= 1'b0;
    end
    else begin            // Normal operation
        q <= d;
    end
end

endmodule