module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// Parallel computation of next state
wire [3:0] next_count;
wire at_max = (out == 4'd11);
assign next_count = at_max ? 4'b0000 : (out + 1'b1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= next_count;
    end
    // Else maintain current value (implicit)
end

endmodule