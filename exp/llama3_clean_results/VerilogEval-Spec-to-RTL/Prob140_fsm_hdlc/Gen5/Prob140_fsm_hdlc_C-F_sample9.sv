module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] state; // 8 bits to represent 8 states using one-hot encoding
reg disc_reg, flag_reg, err_reg;
reg clk_enable; // clock enable signal for clock gating

// Define the states using one-hot encoding
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
        clk_enable <= 1; // enable clock by default
    end else if (clk_enable) begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            IDLE: begin
                if (in) state <= ONE;
                else state <= IDLE;
            end
            ONE: begin
                if (in) state <= TWO_ONES;
                else state <= IDLE;
            end
            TWO_ONES: begin
                if (in) state <= THREE_ONES;
                else state <= IDLE;
            end
            THREE_ONES: begin
                if (in) state <= FOUR_ONES;
                else state <= IDLE;
            end
            FOUR_ONES: begin
                if (in) state <= FIVE_ONES;
                else state <= IDLE;
            end
            FIVE_ONES: begin
                if (in) state <= SIX_ONES;
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
            end
            SEVEN_ONES: begin
                if (~in) state <= IDLE;
                else begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end
            end
        endcase
    end else begin
        state <= state; // hold state when clock is gated
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

// clock gating logic
always @(posedge clk) begin
    if (reset) begin
        clk_enable <= 1; // enable clock by default
    end else if (state == IDLE && ~in) begin
        clk_enable <= 0; // disable clock when idle and no input
    end else begin
        clk_enable <= 1; // enable clock when not idle or input is present
    end
end

endmodule