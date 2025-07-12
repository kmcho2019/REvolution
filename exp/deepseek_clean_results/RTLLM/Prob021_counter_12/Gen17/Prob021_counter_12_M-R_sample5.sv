module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// Next count value calculation
wire [3:0] next_out;
assign next_out = (out == 4'b1011) ? 4'b0000 : (out + 1'b1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous active low reset
        out <= 4'b0000;
    end else if (valid_count) begin
        // Synchronous counting when enabled
        out <= next_out;
    end
    // Implicit else: out retains value when valid_count is low
end

endmodule