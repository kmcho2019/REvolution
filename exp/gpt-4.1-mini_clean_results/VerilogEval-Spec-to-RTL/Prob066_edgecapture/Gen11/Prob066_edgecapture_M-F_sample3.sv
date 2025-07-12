module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;    // Synchronously reset prev_in to zero
            out <= 32'b0;        // Clear output on synchronous reset
        end else begin
            // Capture falling edges: bits that were '1' in prev_in and now '0' in in
            out <= out | (prev_in & ~in);
            prev_in <= in;       // Update previous input for next comparison
        end
    end

endmodule