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
    MONITOR_X1,
    MONITOR_X2,
    MONITOR_X3,
    SET_G,
    MONITOR_Y1,
    MONITOR_Y2
} state, next_state;

reg f_reg;
reg g_reg;
reg [1:0] y_counter;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        y_counter <= 2'b00;
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == SET_F) begin
            f_reg <= 1'b1;
        end else begin
            f_reg <= 1'b0;
        end
        if (next_state == SET_G) begin
            g_reg <= 1'b1;
        end
        if (next_state == MONITOR_Y2 && y_counter == 2) begin
            g_reg <= 1'b0;
        end
        if (next_state == MONITOR_Y1 || next_state == MONITOR_Y2) begin
            y_counter <= y_counter + 1'b1;
        end else begin
            y_counter <= 2'b00;
        end
    end
end

always @ (*) begin
    case (state)
        IDLE: begin
            if (!resetn) begin
                next_state = IDLE;
            end else begin
                next_state = SET_F;
            end
        end
        SET_F: begin
            next_state = MONITOR_X1;
        end
        MONITOR_X1: begin
            if (x) begin
                next_state = MONITOR_X2;
            end else begin
                next_state = MONITOR_X1;
            end
        end
        MONITOR_X2: begin
            if (!x) begin
                next_state = MONITOR_X3;
            end else begin
                next_state = MONITOR_X1;
            end
        end
        MONITOR_X3: begin
            if (x) begin
                next_state = SET_G;
            end else begin
                next_state = MONITOR_X1;
            end
        end
        SET_G: begin
            next_state = MONITOR_Y1;
        end
        MONITOR_Y1: begin
            if (y) begin
                next_state = SET_G; // Stay in SET_G state if y is 1
            end else if (y_counter == 1) begin
                next_state = MONITOR_Y2;
            end else begin
                next_state = MONITOR_Y1;
            end
        end
        MONITOR_Y2: begin
            if (y) begin
                next_state = SET_G; // Stay in SET_G state if y is 1
            end else if (y_counter == 2) begin
                next_state = IDLE;
            end else begin
                next_state = MONITOR_Y2;
            end
        end
    endcase
end

assign f = f_reg;
assign g = g_reg;

endmodule