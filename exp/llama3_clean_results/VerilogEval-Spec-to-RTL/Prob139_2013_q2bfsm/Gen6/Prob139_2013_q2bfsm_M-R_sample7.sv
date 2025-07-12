module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state;
reg [2:0] next_state;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
    end else begin
        state <= next_state;
    end
end

always @ (*) begin
    case (state)
        0: begin // IDLE
            if (resetn) begin
                next_state = 1;
            end else begin
                next_state = 0;
            end
        end
        1: begin // SET_F
            next_state = 2;
        end
        2: begin // MONITOR_X
            if (x == 1 && state == 2) begin
                next_state = 3;
            end else if (x == 0 && state == 2) begin
                next_state = 2;
            end else begin
                next_state = 2;
            end
        end
        3: begin // DETECT_101
            reg x_prev;
            always @ (posedge clk) begin
                x_prev <= x;
            end
            if (x_prev == 1 && x == 0) begin
                next_state = 4;
            end else begin
                next_state = 3;
            end
        end
        4: begin // SET_G
            next_state = 5;
        end
        5: begin // MONITOR_Y
            reg y_detected;
            always @ (posedge clk) begin
                if (y) begin
                    y_detected <= 1;
                end
            end
            if (y_detected) begin
                next_state = 5;
            end else begin
                reg y_counter;
                always @ (posedge clk) begin
                    if (y) begin
                        y_counter <= 0;
                    end else begin
                        y_counter <= y_counter + 1;
                    end
                end
                if (y_counter == 2) begin
                    next_state = 6;
                end else begin
                    next_state = 5;
                end
            end
        end
        6: begin // FINAL_STATE
            next_state = 6;
        end
    endcase
end

assign f = (state == 1);
assign g = (state >= 5);

endmodule