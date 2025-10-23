module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] state; // One-hot encoding for states
reg disc_reg, flag_reg, err_reg;
wire disc_next, flag_next, err_next;

localparam IDLE = 8'b00000001;
localparam ONE = 8'b00000010;
localparam TWO_ONES = 8'b00000100;
localparam THREE_ONES = 8'b00001000;
localparam FOUR_ONES = 8'b00010000;
localparam FIVE_ONES = 8'b00100000;
localparam SIX_ONES = 8'b01000000;
localparam SEVEN_ONES = 8'b10000000;

// Combinational logic for next state and outputs
assign disc_next = (state == FIVE_ONES && ~in);
assign flag_next = (state == SIX_ONES && ~in);
assign err_next = (state == SIX_ONES && in) || (state == SEVEN_ONES && in);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= disc_next;
        flag_reg <= flag_next;
        err_reg <= err_next;

        case (1'b1) // One-hot decoding for state transitions
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
                else state <= IDLE;
            end
            state[6]: begin // SIX_ONES
                if (in) state <= SEVEN_ONES;
                else state <= IDLE;
            end
            state[7]: begin // SEVEN_ONES
                if (~in) state <= IDLE;
                else state <= SEVEN_ONES;
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule