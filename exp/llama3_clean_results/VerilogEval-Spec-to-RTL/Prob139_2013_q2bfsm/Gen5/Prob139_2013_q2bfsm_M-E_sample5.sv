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
reg [1:0] state, next_state;

// x sequence counter
reg [1:0] x_seq_counter;
reg [1:0] x_seq_expected;

// y counter
reg [1:0] y_counter;

// Output f pulse
reg f_pulse;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_seq_counter <= 0;
        x_seq_expected <= 0;
        y_counter <= 0;
        f_pulse <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (resetn) begin
                    state <= PULSE_F;
                    f_pulse <= 1;
                end
            end
            PULSE_F: begin
                f_pulse <= 0;
                state <= WAIT_X_SEQUENCE;
                x_seq_counter <= 0;
                x_seq_expected <= 0;
            end
            WAIT_X_SEQUENCE: begin
                if (x) begin
                    x_seq_counter <= x_seq_counter + 1;
                    if (x_seq_counter == 3) begin
                        state <= CONTROL_G;
                        x_seq_counter <= 0;
                    end
                end else begin
                    x_seq_counter <= 0;
                end
            end
            CONTROL_G: begin
                if (y) begin
                    g <= 1;
                end else begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 2) begin
                        g <= 0;
                    end
                end
            end
        endcase
        f <= f_pulse;
    end
end

always @ (*) begin
    case (state)
        IDLE: next_state = (resetn)? PULSE_F : IDLE;
        PULSE_F: next_state = WAIT_X_SEQUENCE;
        WAIT_X_SEQUENCE: next_state = (x_seq_counter == 3)? CONTROL_G : WAIT_X_SEQUENCE;
        CONTROL_G: next_state = CONTROL_G;
    endcase
end

endmodule