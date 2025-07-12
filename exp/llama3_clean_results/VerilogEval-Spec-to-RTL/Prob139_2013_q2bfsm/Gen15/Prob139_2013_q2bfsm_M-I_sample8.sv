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
reg x_seq_detect;
reg [1:0] y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_prev <= 0;
        x_seq_detect <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // RESET
                if (resetn) begin
                    state <= 1;
                    f <= 1;
                end
            end
            1: begin // INIT
                f <= 0;
                state <= 2;
            end
            2: begin // X_DETECT
                if (x_prev == 1 && !x && x_seq_detect == 0) begin
                    x_seq_detect <= 1;
                end else if (x && x_seq_detect == 1) begin
                    state <= 3;
                    g <= 1;
                end
                x_prev <= x;
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
    end
end

endmodule