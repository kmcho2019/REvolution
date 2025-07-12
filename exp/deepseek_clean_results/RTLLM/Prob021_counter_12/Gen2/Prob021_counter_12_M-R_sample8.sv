module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

reg [3:0] next_out;

// Combinational next state logic
always @(*) begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        next_out = (out == 4'b1011) ? 4'b0000 : (out + 1'b1);
    end else begin
        next_out = out;  // Hold current value when not counting
    end
end

// Sequential state transition
always @(posedge clk) begin
    out <= next_out;
end

endmodule