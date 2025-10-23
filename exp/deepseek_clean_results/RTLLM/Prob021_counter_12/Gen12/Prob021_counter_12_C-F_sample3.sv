module counter_12 (
    input wire rst_n,          // Active low reset (synchronous)
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// Next state logic
wire [3:0] next_count;
assign next_count = (out == 4'd11) ? 4'b0000 : out + 1'b1;

// Register update with synchronous control
always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end
    else if (valid_count) begin
        out <= next_count;
    end
    // else hold current value
end

endmodule