module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    // Two-stage input synchronization registers for robust edge detection
    reg [31:0] sync_in;
    reg [31:0] prev_sync_in;

    always @(posedge clk) begin
        if (reset) begin
            sync_in      <= 32'b0;
            prev_sync_in <= 32'b0;
            out          <= 32'b0;
        end else begin
            // First stage of synchronization
            sync_in <= in;

            // Detect falling edges between sync_in and prev_sync_in
            out <= out | (prev_sync_in & ~sync_in);

            // Update previous synchronized input
            prev_sync_in <= sync_in;
        end
    end

endmodule