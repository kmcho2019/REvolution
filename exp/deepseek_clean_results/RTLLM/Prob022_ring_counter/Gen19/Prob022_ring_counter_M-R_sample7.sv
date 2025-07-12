module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 8'b00000001;  // Initialize with LSB set
    end
    else begin
        // Rotate left with wrap-around
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
end

assign out = shift_reg;

endmodule