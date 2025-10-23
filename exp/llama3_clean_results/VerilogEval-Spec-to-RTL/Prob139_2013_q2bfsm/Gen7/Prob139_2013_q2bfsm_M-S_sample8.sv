module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [2:0] {
    RESET,
    SET_F,
    SEQ_1,
    SEQ_0,
    SEQ_1_AGAIN,
    MONITOR_Y_1,
    MONITOR_Y_2,
    PERM_G
} state, next_state;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            RESET: begin
                if (resetn) next_state <= SET_F;
            end
            SET_F: begin
                f <= 1;
                next_state <= SEQ_1;
            end
            SEQ_1: begin
                f <= 0;
                if (x) next_state <= SEQ_0;
                else next_state <= SEQ_1;
            end
            SEQ_0: begin
                if (!x) next_state <= SEQ_1_AGAIN;
                else next_state <= SEQ_1;
            end
            SEQ_1_AGAIN: begin
                if (x) next_state <= MONITOR_Y_1;
                else next_state <= SEQ_1;
            end
            MONITOR_Y_1: begin
                if (y) next_state <= PERM_G;
                else next_state <= MONITOR_Y_2;
            end
            MONITOR_Y_2: begin
                if (y) next_state <= PERM_G;
                else next_state <= PERM_G; // set g to 0 and stay here is not needed
            end
            PERM_G: begin
                g <= 1;
            end
        endcase
    end
end

endmodule