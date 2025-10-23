module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [6:0] shift_reg; // 7-bit shift register to store the last 7 bits
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 7'b0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        // Shift the input bit into the register
        shift_reg <= {shift_reg[5:0], in};

        // Check for the patterns
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        // Discard bit pattern: 0111110
        if (shift_reg == 7'b0111110) begin
            disc_reg <= 1;
        end

        // Flag pattern: 01111110
        if (shift_reg == 7'b01111110) begin
            flag_reg <= 1;
        end

        // Error pattern: 7 or more consecutive 1s
        if (shift_reg == 7'b1111111) begin
            err_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule