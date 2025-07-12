module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg x_prev1;
reg x_prev2;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_prev1 <= 0;
        x_prev2 <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (resetn) begin
                    state <= 1;
                end
            end
            1: begin // SET_F
                f <= 1;
                state <= 2;
            end
            2: begin // MONITOR_X
                x_prev2 <= x_prev1;
                x_prev1 <= x;
                if (x_prev2 == 1 && x_prev1 == 0 && x == 1) begin
                    state <= 3;
                end
            end
            3: begin // SET_G
                g <= 1;
                state <= 4;
            end
            4: begin // WAIT_Y
                if (y) begin
                    state <= 5;
                end else if (state == 4) begin
                    state <= 6;
                end
            end
            5: begin // FINAL_G
                g <= 1;
            end
            6: begin // FINAL_G
                g <= 0;
            end
        endcase
        if (state != 1) begin
            f <= 0;
        end
    end
end

endmodule