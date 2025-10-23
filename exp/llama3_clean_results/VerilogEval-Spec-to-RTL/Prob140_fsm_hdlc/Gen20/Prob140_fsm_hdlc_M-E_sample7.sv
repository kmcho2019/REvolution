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

        // Shift the input into the shift register
        shift_reg <= {shift_reg[5:0], in};

        // Check for flag pattern
        if (shift_reg == 7'b01111110) begin
            flag_reg <= 1;
        end

        // Check for discard pattern
        if (shift_reg[6:1] == 7'b0111111 && ~in) begin
            disc_reg <= 1;
        end

        // Check for error condition
        if (shift_reg == 7'b1111111) begin
            err_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule