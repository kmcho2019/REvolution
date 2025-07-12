module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [6:0] shift_reg; // 7-bit shift register
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 7'b0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        // Shift in the new bit
        shift_reg <= {shift_reg[5:0], in};

        // Check for sequences
        if (shift_reg == 7'b01111110) begin
            flag_reg <= 1;
        end else if (shift_reg == 7'b0111110) begin
            disc_reg <= 1;
        end else if (shift_reg == 7'b1111111) begin
            err_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule