module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

wire [3:0] next_out;

// Combinational logic for next state
assign next_out = (!rst_n) ? 4'b0000 :          // Reset condition
                  (valid_count) ?                // Counting enabled
                    (out == 4'b1011) ? 4'b0000 : // Wrap-around
                    (out + 1'b1) :               // Increment
                  out;                          // Hold value

// Sequential logic (flip-flops)
always @(posedge clk) begin
    out <= next_out;
end

endmodule