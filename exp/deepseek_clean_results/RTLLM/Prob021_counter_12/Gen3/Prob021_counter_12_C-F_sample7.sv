module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= (out == 4'd11) ? 4'b0000 : out + 1'b1;
    end
    // else hold current value (implicit)
end

endmodule