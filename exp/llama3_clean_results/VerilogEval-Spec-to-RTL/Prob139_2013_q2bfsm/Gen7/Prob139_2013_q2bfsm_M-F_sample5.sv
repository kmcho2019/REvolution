module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
parameter IDLE = 2'b00, PULSE_F = 2'b01, WAIT_X_SEQUENCE = 2'b10, CONTROL_G = 2'b11;

// Current state
reg [1:0] state, next_state;

// x sequence detector
reg x_prev;
reg x_count;

// y counter
reg [1:0] y_count;

// Output f pulse
reg f_pulse;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_prev <= 0;
        x_count <= 0;
        y_count <= 0;
        f_pulse <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                f_pulse <= 0;
            end
            PULSE_F: begin
                f_pulse <= 1;
                state <= WAIT_X_SEQUENCE;
            end
            WAIT_X_SEQUENCE: begin
                if (x) begin
                    if (x_prev == 0 && x_count == 1) begin
                        state <= CONTROL_G;
                    end else if (x_prev == 1) begin
                        x_count <= 1;
                    end else begin
                        x_count <= 0;
                    end
                end else if (x_prev == 1 && x_count == 0) begin
                    x_count <= 2;
                end
                x_prev <= x;
            end
            CONTROL_G: begin
                if (y) begin
                    g <= 1;
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2 && g == 0) begin
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
        WAIT_X_SEQUENCE: next_state = (state == WAIT_X_SEQUENCE && x_prev == 0 && x_count == 1)? CONTROL_G : WAIT_X_SEQUENCE;
        CONTROL_G: next_state = CONTROL_G;
    endcase
end

endmodule