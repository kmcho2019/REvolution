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

// x sequence detection
reg x_prev, x_prev_prev;

// y counter
reg [1:0] y_counter;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_prev <= 0;
        x_prev_prev <= 0;
        y_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        x_prev_prev <= x_prev;
        x_prev <= x;
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
                if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
                    state <= CONTROL_G;
                end
            end
            CONTROL_G: begin
                if (y) begin
                    g <= 1;
                    y_counter <= 0;
                end else begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 2) begin
                        g <= 0;
                    end
                end
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        IDLE: next_state = (resetn)? PULSE_F : IDLE;
        PULSE_F: next_state = WAIT_X_SEQUENCE;
        WAIT_X_SEQUENCE: next_state = (x_prev_prev == 1 && x_prev == 0 && x == 1)? CONTROL_G : WAIT_X_SEQUENCE;
        CONTROL_G: next_state = CONTROL_G;
    endcase
end

endmodule