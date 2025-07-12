module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Simple and efficient counter logic
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        q <= 4'd0;
    end else begin
        // Direct incrementation for simplicity and efficiency
        q <= q + 1'd1;
    end
end

endmodule