module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

wire [3:0] next_count;

// Next state logic
assign next_count = (out == 4'b1011) ? 4'b0000 : (out + 1'b1);

always @(posedge clk) begin
    if (!rst_n) begin
        // Synchronous active low reset
        out <= 4'b0000;
    end else if (valid_count) begin
        // Update counter only when enabled
        out <= next_count;
    end
    // Else maintain current value
end

endmodule