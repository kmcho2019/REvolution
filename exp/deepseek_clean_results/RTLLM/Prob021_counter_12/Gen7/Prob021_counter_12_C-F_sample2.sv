module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

wire gated_clk;
assign gated_clk = clk & valid_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end
end

always @(posedge gated_clk) begin
    // Simplified terminal count detection (check for 1011 pattern)
    if (out[3] & out[1] & out[0]) begin  // out == 4'b1011
        out <= 4'b0000;
    end else begin
        out <= out + 1'b1;
    end
end

endmodule