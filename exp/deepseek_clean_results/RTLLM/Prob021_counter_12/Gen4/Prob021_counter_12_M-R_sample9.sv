module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// Combinational next state logic
wire [3:0] next_out;
assign next_out = (out == 4'b1011) ? 4'b0000 : (out + 1'b1);

// Sequential state update
always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= next_out;
    end
    // else hold current value (implicit)
end

endmodule