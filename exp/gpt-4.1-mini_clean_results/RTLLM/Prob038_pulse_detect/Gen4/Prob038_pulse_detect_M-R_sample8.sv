module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    reg [2:0] shift_reg; // Shift register to hold last 3 samples of data_in

    // Shift in data_in on each clock, reset shift_reg to zero on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 3'b000;
        else
            shift_reg <= {shift_reg[1:0], data_in};
    end

    // Detect pattern 0->1->0 in the last 3 cycles: shift_reg = {previous_2, previous_1, current}
    // Specifically pattern is: shift_reg = 3'b010, meaning:
    // shift_reg[2] = 0 (two cycles ago)
    // shift_reg[1] = 1 (one cycle ago)
    // shift_reg[0] = 0 (current)
    assign data_out = (shift_reg == 3'b010) ? 1'b1 : 1'b0;

endmodule