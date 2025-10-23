module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] shift_reg; // Shift register to store recent input history
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        // Shift in the new input bit
        shift_reg <= {in, shift_reg[7:1]};

        // Check for flag condition (01111110)
        if (shift_reg == 8'b01111110) begin
            flag_reg <= 1;
        end

        // Check for discard condition (5 consecutive ones followed by a zero)
        if (shift_reg[7:3] == 5'b11111 && ~shift_reg[2]) begin
            disc_reg <= 1;
        end

        // Check for error condition (7 or more consecutive ones)
        if (shift_reg[7:1] == 7'b1111111) begin
            err_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule