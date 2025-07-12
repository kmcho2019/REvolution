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

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_seq <= 0;
        y_count <= 0;
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
                f <= 1;
                state <= WAIT_X_SEQUENCE;
            end
            WAIT_X_SEQUENCE: begin
                if (x) begin
                    if (x_seq == 2'b10) begin
                        x_seq <= 2'b00;
                    end else if (x_seq == 2'b01) begin
                        x_seq <= 2'b11;
                    end else begin
                        x_seq <= 2'b01;
                    end
                end else if (x_seq == 2'b11) begin
                    x_seq <= 2'b10;
                    state <= CONTROL_G;
                end else if (x_seq == 2'b01) begin
                    x_seq <= 2'b00;
                end
                f <= 0;
            end
            CONTROL_G: begin
                if (y) begin
                    g <= 1;
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        g <= 0;
                    end
                end
            end
        endcase
    end
end

endmodule