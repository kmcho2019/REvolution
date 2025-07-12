module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] state; // One-hot encoding for 8 states
reg disc_reg, flag_reg, err_reg;

localparam IDLE = 8'b00000001;
localparam ONE = 8'b00000010;
localparam TWO_ONES = 8'b00000100;
localparam THREE_ONES = 8'b00001000;
localparam FOUR_ONES = 8'b00010000;
localparam FIVE_ONES = 8'b00100000;
localparam SIX_ONES = 8'b01000000;
localparam SEVEN_ONES = 8'b10000000;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (1'b1)
            state[0]: begin // IDLE
                if (in) state <= ONE;
                else state <= IDLE;
            end
            state[1]: begin // ONE
                if (in) state <= TWO_ONES;
                else state <= IDLE;
            end
            state[2]: begin // TWO_ONES
                if (in) state <= THREE_ONES;
                else state <= IDLE;
            end
            state[3]: begin // THREE_ONES
                if (in) state <= FOUR_ONES;
                else state <= IDLE;
            end
            state[4]: begin // FOUR_ONES
                if (in) state <= FIVE_ONES;
                else state <= IDLE;
            end
            state[5]: begin // FIVE_ONES
                if (in) state <= SIX_ONES;
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
            end
            state[6]: begin // SIX_ONES
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
            end
            state[7]: begin // SEVEN_ONES
                if (~in) state <= IDLE;
                else begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end
            end
        endcase

        disc_reg <= (state[5] && ~in);
        flag_reg <= (state[6] && ~in);
        err_reg <= (state[6] && in) || (state[7] && in);
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule