module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset)
        shift_reg <= 8'b00000001;  // Initialize with LSB set
    else
        shift_reg <= {shift_reg[6:0], shift_reg[7]};  // Circular shift
end

assign out = shift_reg;

endmodule