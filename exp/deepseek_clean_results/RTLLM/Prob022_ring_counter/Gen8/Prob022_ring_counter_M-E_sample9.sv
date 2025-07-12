module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

wire wrap_around = out[7];  // Detect when we need to wrap around
wire [7:0] next_state = (out << 1) | (wrap_around ? 8'b00000001 : 8'b00000000);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end else begin
        out <= next_state;
    end
end

endmodule