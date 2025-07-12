module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg x_prev;
reg x_prev_prev;
reg y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_prev <= 0;
        x_prev_prev <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // RESET
                if (resetn) begin
                    state <= 1;
                end
            end
            1: begin // INIT
                f <= 1;
                state <= 2;
            end
            2: begin // X_DETECT
                x_prev_prev <= x_prev;
                x_prev <= x;
                if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
                    state <= 3;
                    g <= 1;
                end
            end
            3: begin // Y_WAIT
                if (y) begin
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer == 2) begin
                        g <= 0;
                    end
                end
            end
        endcase
        if (state != 1) begin
            f <= 0;
        end
    end
end

endmodule