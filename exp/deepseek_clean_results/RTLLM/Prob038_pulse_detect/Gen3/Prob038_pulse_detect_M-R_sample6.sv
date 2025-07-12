module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [2:0] shift_reg;

// Shift register to track last 3 samples
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
    end else begin
        shift_reg <= {shift_reg[1:0], data_in};
    end
end

// Combinational output - detects 0-1-0 pattern
assign data_out = (shift_reg == 3'b010);

endmodule