module counter_12 (
    input wire rst_n,         // Active low reset (synchronous)
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

parameter MAX_COUNT = 4'd11;  // Parameter for maintainability

always @(posedge clk) begin
    if (!rst_n) begin
        // Synchronous active low reset
        out <= 4'b0000;
    end else if (valid_count) begin
        // Efficient wrap-around with synchronous enable
        out <= (out == MAX_COUNT) ? 4'b0000 : (out + 1'b1);
    end
    // Implicit else: out retains value when valid_count=0
end

endmodule