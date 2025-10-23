module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    // Two-stage synchronizer for input to avoid metastability and glitches
    reg [31:0] in_sync_0;
    reg [31:0] in_sync_1;
    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            in_sync_0 <= 32'hFFFFFFFF; // Initialize synchronized input to all 1s on reset
            in_sync_1 <= 32'hFFFFFFFF;
            prev_in   <= 32'hFFFFFFFF; // Initialize prev_in to all 1s to prevent false edge detection after reset
            out       <= 32'b0;
        end else begin
            // Synchronize input
            in_sync_0 <= in;
            in_sync_1 <= in_sync_0;

            // Detect falling edges: bits that were 1 in prev_in and 0 in current synchronized input
            out <= out | (prev_in & ~in_sync_1);

            // Update prev_in to current synchronized input for next cycle
            prev_in <= in_sync_1;
        end
    end

endmodule