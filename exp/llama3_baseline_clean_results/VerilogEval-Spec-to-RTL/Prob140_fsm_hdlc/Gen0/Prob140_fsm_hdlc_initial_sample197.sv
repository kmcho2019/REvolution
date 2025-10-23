module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

enum logic [2:0] {
    IDLE,
    ONE,
    TWO_ONES,
    THREE_ONES,
    FOUR_ONES,
    FIVE_ONES,
    SIX_ONES,
    ERROR
} state, nextState;

logic discReg, flagReg, errReg;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        discReg <= 0;
        flagReg <= 0;
        errReg <= 0;
    end else begin
        state <= nextState;
        discReg <= (nextState == FIVE_ONES && in == 0) ? 1 : 0;
        flagReg <= (nextState == SIX_ONES && in == 0) ? 1 : 0;
        errReg <= (nextState == ERROR) ? 1 : 0;
    end
end

always_comb begin
    disc = discReg;
    flag = flagReg;
    err = errReg;

    case (state)
        IDLE: begin
            if (in == 1) begin
                nextState = ONE;
            end else begin
                nextState = IDLE;
            end
        end
        ONE: begin
            if (in == 1) begin
                nextState = TWO_ONES;
            end else begin
                nextState = IDLE;
            end
        end
        TWO_ONES: begin
            if (in == 1) begin
                nextState = THREE_ONES;
            end else begin
                nextState = IDLE;
            end
        end
        THREE_ONES: begin
            if (in == 1) begin
                nextState = FOUR_ONES;
            end else begin
                nextState = IDLE;
            end
        end
        FOUR_ONES: begin
            if (in == 1) begin
                nextState = FIVE_ONES;
            end else begin
                nextState = IDLE;
            end
        end
        FIVE_ONES: begin
            if (in == 1) begin
                nextState = SIX_ONES;
            end else begin
                nextState = IDLE;
            end
        end
        SIX_ONES: begin
            if (in == 1) begin
                nextState = ERROR;
            end else begin
                nextState = IDLE;
            end
        end
        ERROR: begin
            if (in == 0) begin
                nextState = IDLE;
            end else begin
                nextState = ERROR;
            end
        end
    endcase
end

endmodule