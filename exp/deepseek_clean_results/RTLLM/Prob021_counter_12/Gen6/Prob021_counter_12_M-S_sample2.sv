module counter_12 (
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out = 0   // 4-bit counter output (initialized to 0)
);

always @(posedge clk) begin
    if (valid_count) begin
        out <= out + 1'b1;
    end
end

endmodule