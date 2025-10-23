module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] shift_reg;
reg msb_temp;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b00000001;  // Initialize with LSB set
    end
    else begin
        msb_temp = shift_reg[7];      // Store MSB
        shift_reg <= shift_reg << 1;  // Shift left
        shift_reg[0] <= msb_temp;     // Wrap around MSB to LSB
    end
end

assign out = shift_reg;

endmodule