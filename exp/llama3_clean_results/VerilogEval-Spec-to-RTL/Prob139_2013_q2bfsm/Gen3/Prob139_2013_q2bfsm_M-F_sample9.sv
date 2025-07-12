module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

enum logic [2:0] {IDLE, PULSE_F, WAIT_X_SEQUENCE, WAIT_Y, SET_G, RESET_G} state;

reg x_prev;
reg x_prev_prev;
reg y_count;
reg f_reg;
reg g_reg;

initial begin
    state = IDLE;
    x_prev = 0;
    x_prev_prev = 0;
    y_count = 0;
    f_reg = 0;
    g_reg = 0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_prev <= 0;
        x_prev_prev <= 0;
        y_count <= 0;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                state <= PULSE_F;
                f_reg <= 1;
            end
            PULSE_F: begin
                state <= WAIT_X_SEQUENCE;
                f_reg <= 0;
                x_prev_prev <= 0;
                x_prev <= 0;
            end
            WAIT_X_SEQUENCE: begin
                x_prev_prev <= x_prev;
                x_prev <= x;
                if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
                    state <= WAIT_Y;
                end
            end
            WAIT_Y: begin
                if (y) begin
                    state <= SET_G;
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        state <= RESET_G;
                    end
                end
            end
            SET_G: begin
                g_reg <= 1;
                // Stay in SET_G
            end
            RESET_G: begin
                g_reg <= 0;
                // Stay in RESET_G
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule