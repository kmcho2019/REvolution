module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;   // Initialize prev_in to current input to avoid false detection after reset
            out <= 32'b0;    // Clear latched output on reset
        end else begin
            out <= out | (prev_in & ~in); // Capture falling edges and latch them
            prev_in <= in;                // Update prev_in for next cycle detection
        end
    end

endmodule