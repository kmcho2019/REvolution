module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

enum logic [2:0] {
    IDLE,
    SET_F,
    MONITOR_X,
    SET_G,
    MONITOR_Y
} state, next_state;

reg [1:0] x_sequence;
reg [1:0] y_counter;
reg f_reg;
reg g_reg;

initial begin
    state = IDLE;
    x_sequence = 2'b00;
    y_counter = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state = IDLE;
        x_sequence = 2'b00;
        y_counter = 2'b00;
        f_reg = 1'b0;
        g_reg = 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (resetn) begin
                    state = SET_F;
                    f_reg = 1'b1;
                end
            end
            SET_F: begin
                state = MONITOR_X;
                f_reg = 1'b0;
            end
            MONITOR_X: begin
                x_sequence = {x, x_sequence[0]};
                if (x_sequence == 2'b10) begin
                    x_sequence = 2'b00;
                    if (x) begin
                        state = SET_G;
                        g_reg = 1'b1;
                    end
                end
            end
            SET_G: begin
                state = MONITOR_Y;
            end
            MONITOR_Y: begin
                y_counter = y_counter + 1'b1;
                if (y) begin
                    g_reg = 1'b1;
                    y_counter = 2'b00;
                    state = IDLE; // Transition back to IDLE state
                end else if (y_counter == 2'b10) begin
                    g_reg = 1'b0;
                    y_counter = 2'b00;
                    state = IDLE; // Transition back to IDLE state
                end
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule