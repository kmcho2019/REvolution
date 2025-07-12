module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] x_sequence_counter;
reg [1:0] y_detection_counter;
reg y_detected;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_sequence_counter <= 0;
        y_detection_counter <= 0;
        y_detected <= 0;
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
            1: begin // PULSE_F
                f <= 0;
                state <= 2;
            end
            2: begin // CONTROL_G
                case (x_sequence_counter)
                    0: begin
                        if (x) begin
                            x_sequence_counter <= 1;
                        end
                    end
                    1: begin
                        if (!x) begin
                            x_sequence_counter <= 2;
                        end else begin
                            x_sequence_counter <= 1;
                        end
                    end
                    2: begin
                        if (x) begin
                            x_sequence_counter <= 0;
                            y_detection_counter <= 1;
                        end else begin
                            x_sequence_counter <= 2;
                        end
                    end
                endcase

                if (y_detection_counter > 0) begin
                    if (y) begin
                        y_detected <= 1;
                        g <= 1;
                    end else begin
                        y_detection_counter <= y_detection_counter + 1;
                        if (y_detection_counter == 3) begin
                            g <= 0;
                        end
                    end
                end

                if (y_detected) begin
                    g <= 1;
                end
            end
        endcase
    end
end

endmodule