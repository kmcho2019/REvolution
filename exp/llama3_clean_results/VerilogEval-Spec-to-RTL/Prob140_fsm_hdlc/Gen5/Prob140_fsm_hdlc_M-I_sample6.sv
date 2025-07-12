module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
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
    next_state = state;
    disc = 0;
    flag = 0;
    err = 0;

    case (state)
        IDLE: begin
            if (in) begin
                next_state = START_BIT;
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
                    // discard the bit
                end else if (consecutive_ones >= 6) begin
                    next_state = FLAG;
                    flag = 1;
                    if (consecutive_ones > 6) begin
                        next_state = ERROR;
                        err = 1;
                    end
                end
            end else begin
                if (consecutive_ones == 5) begin
                    disc = 1;
                end
                next_state = IDLE;
            end
        end
        FLAG: begin
            next_state = IDLE;
        end
        ERROR: begin
            if (~in) begin
                next_state = IDLE;
            end
            err = 1;
        end
    endcase
end

endmodule