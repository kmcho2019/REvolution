module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
parameter IDLE = 0, PULSE_F = 1, WAIT_X_SEQUENCE = 2, CONTROL_G = 3, G_SET = 4;

// Current state
reg [1:0] state;

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
                x_prev_prev <= x_prev;
                x_prev <= x;
            end
            CONTROL_G: begin
                if (y) begin
                    state <= G_SET;
                    g <= 1;
                end else begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 2) begin
                        state <= G_SET;
                        g <= 0;
                    end
                end
            end
            G_SET: begin
                // No transition from this state
            end
        endcase
    end
end

endmodule