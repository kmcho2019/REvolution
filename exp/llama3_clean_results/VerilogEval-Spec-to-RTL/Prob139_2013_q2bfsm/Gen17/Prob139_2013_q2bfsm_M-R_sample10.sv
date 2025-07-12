module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the state machine states as enumerations
enum logic [2:0] {
    STATE_RESET,
    STATE_WAIT_FOR_X,
    STATE_SET_F_HIGH,
    STATE_WAIT_FOR_Y
} state, next_state;

reg [1:0] x_seq; // 0: Initial, 1: x=1, 2: x=0, x=1
reg [1:0] y_timeout; // Counts clocks after x sequence is detected

// Next state logic
always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_RESET;
        x_seq <= 0;
        y_timeout <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            STATE_RESET: begin
                state <= STATE_WAIT_FOR_X;
                f <= 1; // Set f high for one clock cycle
            end
            STATE_WAIT_FOR_X: begin
                case (x_seq)
                    0: begin
                        if (x) begin
                            x_seq <= 1;
                        end else begin
                            x_seq <= 0;
                        end
                    end
                    1: begin
                        if (!x) begin
                            x_seq <= 2;
                        end else begin
                            x_seq <= 1;
                        end
                    end
                    2: begin
                        if (x) begin
                            state <= STATE_SET_F_HIGH;
                            x_seq <= 0;
                        end else begin
                            x_seq <= 0; // Reset x_seq
                        end
                    end
                endcase
            end
            STATE_SET_F_HIGH: begin
                state <= STATE_WAIT_FOR_Y;
                f <= 0; // Ensure f is low after the first clock cycle
                g <= 1; // Set g high initially
                y_timeout <= 0;
            end
            STATE_WAIT_FOR_Y: begin
                if (y) begin
                    state <= STATE_WAIT_FOR_Y; // Stay in this state, g already set high
                    y_timeout <= 0; // Reset y_timeout
                end else begin
                    y_timeout <= y_timeout + 1;
                    if (y_timeout == 2) begin
                        g <= 0; // Set g low if y doesn't occur within 2 clocks
                        state <= STATE_WAIT_FOR_X; // Return to initial state
                    end
                end
            end
        endcase
    end
end

endmodule