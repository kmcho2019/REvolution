module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in_sync;  // First stage register for 'in'
    reg [31:0] prev_in;       // Second stage register for stable sampling

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 32'b0;
            prev_in_sync <= 32'hFFFFFFFF; // Initialize to all ones to avoid false detection
            prev_in <= 32'hFFFFFFFF;
        end else begin
            prev_in_sync <= in;
            prev_in <= prev_in_sync;

            // Detect 1-to-0 transitions: prev_in=1 and current in=0
            // out accumulates these events until reset
            out <= out | (prev_in & ~prev_in_sync);
        end
    end

endmodule