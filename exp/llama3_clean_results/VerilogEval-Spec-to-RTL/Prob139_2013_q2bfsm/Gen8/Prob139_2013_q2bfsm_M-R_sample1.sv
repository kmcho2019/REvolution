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
reg [1:0] state;

// x sequence detector
reg [1:0] x_seq;

// y counter
reg [1:0] y_count;

// Output f pulse
reg f_pulse;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_seq <= 0;
        y_count <= 0;
        f_pulse <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (resetn) begin
                    state <= PULSE_F;
                end
            end
            PULSE_F: begin
                f_pulse <= 1;
                state <= WAIT_X_SEQUENCE;
            end
            WAIT_X_SEQUENCE: begin
                if (x) begin
                    x_seq <= x_seq + 1;
                end else if (x_seq == 2) begin
                    state <= CONTROL_G;
                    x_seq <= 0;
                end else begin
                    x_seq <= 0;
                end
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
        if (state == PULSE_F) begin
            f_pulse <= 1;
        end else begin
            f_pulse <= 0;
        end
        f <= f_pulse;
    end
end

endmodule