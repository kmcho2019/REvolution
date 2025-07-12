module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
parameter IDLE = 0, PULSE_F = 1, WAIT_X_SEQUENCE = 2, CONTROL_G = 3;

// Current state
reg [1:0] state;

// x sequence detection
reg [1:0] x_sequence_counter;

// y detection
reg y_detected;
reg [1:0] y_detection_counter;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_sequence_counter <= 0;
        y_detected <= 0;
        y_detection_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (resetn) begin
                    state <= PULSE_F;
                    f <= 1;
                end
            end
            PULSE_F: begin
                f <= 0;
                state <= WAIT_X_SEQUENCE;
            end
            WAIT_X_SEQUENCE: begin
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
                            state <= CONTROL_G;
                        end else begin
                            x_sequence_counter <= 2;
                        end
                    end
                endcase
            end
            CONTROL_G: begin
                if (!y_detected) begin
                    if (y) begin
                        y_detected <= 1;
                        g <= 1;
                    end else begin
                        y_detection_counter <= y_detection_counter + 1;
                        if (y_detection_counter == 2) begin
                            g <= 0;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule