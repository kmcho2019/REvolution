module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] state;
reg [1:0] x_prev;
reg [1:0] x_prev_prev;
reg [1:0] y_count;
reg f_reg;
reg g_reg;

initial begin
    state = 0;
    x_prev = 0;
    x_prev_prev = 0;
    y_count = 0;
    f_reg = 0;
    g_reg = 0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_prev <= 0;
        x_prev_prev <= 0;
        y_count <= 0;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                state <= 1;
                f_reg <= 1;
            end
            1: begin // PULSE_F
                state <= 2;
                f_reg <= 0;
            end
            2: begin // WAIT_X_SEQUENCE
                x_prev_prev <= x_prev;
                x_prev <= x;
                if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
                    state <= 3;
                end
            end
            3: begin // WAIT_Y
                if (y) begin
                    state <= 4;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        state <= 5;
                    end
                end
            end
            4: begin // SET_G
                g_reg <= 1;
                // Stay in SET_G
            end
            5: begin // RESET_G
                g_reg <= 0;
                // Stay in RESET_G
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule