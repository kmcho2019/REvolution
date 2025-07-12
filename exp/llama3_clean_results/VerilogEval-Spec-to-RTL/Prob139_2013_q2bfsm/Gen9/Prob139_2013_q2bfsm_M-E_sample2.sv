module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [2:0] {
    IDLE,
    SET_F,
    SEQ_1,
    SEQ_2,
    SEQ_3,
    WAIT_Y,
    FINAL
} state, next_state;

reg seq_x_prev;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        seq_x_prev <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (resetn) next_state <= SET_F;
                else next_state <= IDLE;
            end
            SET_F: begin
                f <= 1;
                next_state <= SEQ_1;
            end
            SEQ_1: begin
                if (x) begin
                    seq_x_prev <= x;
                    next_state <= SEQ_2;
                end else next_state <= SEQ_1;
            end
            SEQ_2: begin
                if (!x && seq_x_prev) begin
                    seq_x_prev <= x;
                    next_state <= SEQ_3;
                end else if (x) next_state <= SEQ_1;
                else next_state <= SEQ_2;
            end
            SEQ_3: begin
                if (x) begin
                    seq_x_prev <= x;
                    next_state <= WAIT_Y;
                end else next_state <= SEQ_1;
            end
            WAIT_Y: begin
                if (y) begin
                    g <= 1;
                    next_state <= FINAL;
                end else if (state == WAIT_Y) begin
                    next_state <= (y)? FINAL : (WAIT_Y == WAIT_Y)? FINAL : IDLE;
                end else next_state <= WAIT_Y;
            end
            FINAL: begin
                g <= 1;
                next_state <= FINAL;
            end
        endcase
        if (state != SET_F) f <= 0;
    end
end

endmodule