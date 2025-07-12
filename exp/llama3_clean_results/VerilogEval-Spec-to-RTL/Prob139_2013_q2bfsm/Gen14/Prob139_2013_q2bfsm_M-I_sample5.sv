module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] x_sequence;
reg [1:0] y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_sequence <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (resetn) begin
                    state <= 1;
                    f <= 1;
                end
            end
            1: begin // INIT
                state <= 2;
                f <= 0;
            end
            2: begin // X_SEQUENCE
                case (x_sequence)
                    0: begin
                        if (x) begin
                            x_sequence <= 1;
                        end
                    end
                    1: begin
                        if (!x) begin
                            x_sequence <= 2;
                        end else begin
                            x_sequence <= 1;
                        end
                    end
                    2: begin
                        if (x) begin
                            state <= 3;
                            x_sequence <= 0;
                            g <= 1;
                            y_timer <= 0;
                        end else begin
                            x_sequence <= 2;
                        end
                    end
                endcase
            end
            3: begin // Y_WAIT
                if (y) begin
                    g <= 1;
                    state <= 4; // new state to hold g high permanently
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer == 2) begin
                        g <= 0;
                        state <= 2; // go back to X_SEQUENCE state
                    end
                end
            end
            4: begin // HOLD_G_HIGH
                g <= 1;
            end
        endcase
    end
end

endmodule