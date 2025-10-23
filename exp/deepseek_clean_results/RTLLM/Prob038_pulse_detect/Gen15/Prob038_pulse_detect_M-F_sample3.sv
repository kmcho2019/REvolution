module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [2:0] shift_reg;

// 3-bit shift register to track last three samples
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
    end
end

// Pulse detected when we see 0->1->0 sequence
assign data_out = (shift_reg == 3'b010);

endmodule