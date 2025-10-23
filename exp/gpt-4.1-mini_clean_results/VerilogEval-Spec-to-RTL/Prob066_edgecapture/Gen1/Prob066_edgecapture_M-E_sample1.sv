module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // Two pipeline stages for input delay
    reg [31:0] in_d1, in_d2;

    always @(posedge clk) begin
        if (reset) begin
            in_d1 <= 32'b0;
            in_d2 <= 32'b0;
            out <= 32'b0;
        end else begin
            // Shift input through pipeline
            in_d1 <= in;
            in_d2 <= in_d1;

            // Detect falling edge on each bit (1 -> 0 from in_d2 to in)
            // Condition: bit was 1 two cycles ago, and is 0 now
            // Latch detected falling edges until reset
            out <= out | (in_d2 & ~in);
        end
    end

endmodule