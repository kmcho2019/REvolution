module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] shift_reg; // 8-bit shift register to track the last 8 bits
reg [2:0] counter; // 3-bit counter to track consecutive 1s
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
        counter <= 3'b0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        // Shift the input bit into the shift register
        shift_reg <= {shift_reg[6:0], in};

        // Check for 7 or more consecutive 1s
        if (shift_reg == 8'b11111111 || shift_reg == 8'b01111111 || shift_reg == 8'b00111111 || shift_reg == 8'b00011111 || shift_reg == 8'b00001111 || shift_reg == 8'b00000111 || shift_reg == 8'b00000011 || shift_reg == 8'b00000001) begin
            err_reg <= 1;
        end

        // Check for the flag sequence 01111110
        if (shift_reg == 8'b01111110) begin
            flag_reg <= 1;
        end

        // Check for 5 consecutive 1s and assert discard if the next bit is 0
        if (counter == 3'b101) begin
            if (~in) begin
                disc_reg <= 1;
            end else begin
                err_reg <= 1;
            end
            counter <= 3'b0;
        end else if (in) begin
            counter <= counter + 1;
        end else begin
            counter <= 3'b0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule