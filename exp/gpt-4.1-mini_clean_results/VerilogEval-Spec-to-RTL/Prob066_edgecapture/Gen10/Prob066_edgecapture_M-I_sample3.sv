module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;    // Reset prev_in to zero for deterministic behavior
            out <= 32'b0;        // Clear output on reset
        end else begin
            out <= out | (prev_in & ~in); // Capture falling edges
            prev_in <= in;                // Update previous input
        end
    end

endmodule