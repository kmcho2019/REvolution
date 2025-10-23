module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

enum logic [2:0] {
    IDLE,
    START_BIT,
    CONSECUTIVEONES,
    FLAG,
    ERROR
} state, next_state;

reg [2:0] consecutive_ones;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        consecutive_ones <= 0;
    end else begin
        state <= next_state;
        if (in) begin
            consecutive_ones <= consecutive_ones + 1;
        end else begin
            consecutive_ones <= 0;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (in) begin
                next_state = START_BIT;
            end else begin
                next_state = IDLE;
            end
        end
        START_BIT: begin
            if (in) begin
                next_state = CONSECUTIVEONES;
            end else begin
                next_state = IDLE;
            end
        end
        CONSECUTIVEONES: begin
            if (in) begin
                if (consecutive_ones == 5) begin
                    next_state = CONSECUTIVEONES;
                end else if (consecutive_ones > 5) begin
                    next_state = CONSECUTIVEONES;
                end else begin
                    next_state = CONSECUTIVEONES;
                end
            end else begin
                if (consecutive_ones == 5) begin
                    next_state = IDLE;
                end else if (consecutive_ones == 6) begin
                    next_state = FLAG;
                end else begin
                    next_state = IDLE;
                end
            end
        end
        FLAG: begin
            next_state = IDLE;
        end
        ERROR: begin
            if (~in) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase

    if (state == CONSECUTIVEONES && consecutive_ones > 6) begin
        next_state = ERROR;
    end

    if (state == CONSECUTIVEONES && consecutive_ones == 5 && ~in) begin
        disc = 1;
    end else begin
        disc = 0;
    end

    if (state == FLAG) begin
        flag = 1;
    end else begin
        flag = 0;
    end

    if (state == ERROR) begin
        err = 1;
    end else begin
        err = 0;
    end
end

endmodule