module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [6:0] shift_reg; // Shift register to store last 7 bits of input sequence
reg [2:0] state; // Current state
reg disc_reg, flag_reg, err_reg; // Output registers

parameter IDLE = 3'b000;
parameter FLAG_WAIT = 3'b001;
parameter ERROR_DETECT = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        shift_reg <= 0;
    end else begin
        shift_reg <= {shift_reg[5:0], in}; // Shift in new input bit

        case (state)
            IDLE: begin
                if (shift_reg == 7'b01111110) begin
                    state <= IDLE;
                    flag_reg <= 1;
                end else if (shift_reg == 7'b01111111) begin
                    state <= ERROR_DETECT;
                    err_reg <= 1;
                end else if (shift_reg[6:2] == 5'b11111) begin
                    state <= FLAG_WAIT;
                end
            end
            FLAG_WAIT: begin
                if (!in) begin
                    state <= IDLE;
                    disc_reg <= 1;
                end else begin
                    state <= ERROR_DETECT;
                    err_reg <= 1;
                end
            end
            ERROR_DETECT: begin
                if (!in) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

always @(posedge clk) begin
    if (!reset) begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end
end

endmodule