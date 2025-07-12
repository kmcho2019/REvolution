module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] shift_reg;

// Shift register to track last two samples
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
    end
    else begin
        shift_reg <= {shift_reg[0], data_in};
    end
end

// Pulse detected when we see 0->1 in previous cycle and 0 in current cycle
assign data_out = (shift_reg == 2'b10) & ~data_in;

endmodule