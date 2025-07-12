module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [6:0] shift_reg; // Shift register to store last 7 bits of input sequence
reg state; // Current state (IDLE or ERROR)
reg disc_reg, flag_reg, err_reg; // Output registers

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // IDLE
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        shift_reg <= 0;
    end else begin
        shift_reg <= {shift_reg[5:0], in}; // Shift in new input bit

        if (state == 1'b0) begin // IDLE
            if (shift_reg == 7'b01111110) begin
                flag_reg <= 1;
            end else if (shift_reg[6:2] == 5'b11111 &&!in) begin
                disc_reg <= 1;
            end else if (shift_reg[6:0] == 7'b01111111) begin
                state <= 1'b1; // ERROR
                err_reg <= 1;
            end
        end else begin // ERROR
            if (!in) begin
                state <= 1'b0; // IDLE
            end
        end
    end
end

always @(posedge clk) begin
    if (!reset) begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule