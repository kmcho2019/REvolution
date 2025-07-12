module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [3:0] {
    RESET,
    SET_F,
    DETECT_SEQ,
    MONITOR_Y,
    PERM_G,
    PERM_G_ZERO
} state, next_state;

reg [1:0] seq_counter;
reg [1:0] monitor_counter;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        seq_counter <= 0;
        monitor_counter <= 0;
    end else begin
        state <= next_state;
        case (state)
            RESET: begin
                if (resetn) next_state <= SET_F;
            end
            SET_F: begin
                f <= 1;
                next_state <= DETECT_SEQ;
            end
            DETECT_SEQ: begin
                f <= 0;
                if (x) begin
                    if (seq_counter == 0) seq_counter <= 1;
                    else if (seq_counter == 1 && x == 1) seq_counter <= 0;
                    else if (seq_counter == 1 && x == 0) seq_counter <= 2;
                    else if (seq_counter == 2 && x == 1) next_state <= MONITOR_Y;
                end else begin
                    if (seq_counter == 1) seq_counter <= 0;
                end
            end
            MONITOR_Y: begin
                if (y) begin
                    next_state <= PERM_G;
                    g <= 1;
                end else begin
                    monitor_counter <= monitor_counter + 1;
                    if (monitor_counter == 2) next_state <= PERM_G_ZERO;
                end
            end
            PERM_G: begin
                g <= 1;
            end
            PERM_G_ZERO: begin
                g <= 0;
            end
        endcase
    end
end

endmodule