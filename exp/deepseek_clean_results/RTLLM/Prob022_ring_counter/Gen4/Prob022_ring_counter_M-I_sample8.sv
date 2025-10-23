module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// Synchronous reset and shift logic
always @(posedge clk) begin
    if (reset) begin
        out <= 8'b0000_0001;  // Initialize to first state
    end
    else begin
        out <= {out[6:0], out[7]};  // Circular shift left
    end
end

endmodule