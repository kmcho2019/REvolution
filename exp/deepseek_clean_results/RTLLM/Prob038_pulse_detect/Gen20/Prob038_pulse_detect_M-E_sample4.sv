module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// 3-bit shift register to track last three samples
reg [2:0] shift_reg;

// Shift register update logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
    end
end

// Pulse detection occurs when we see 010 in the shift register
// Output is registered to match clock timing
reg data_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out_reg <= 1'b0;
    end
    else begin
        data_out_reg <= (shift_reg == 3'b010);
    end
end

assign data_out = data_out_reg;

endmodule