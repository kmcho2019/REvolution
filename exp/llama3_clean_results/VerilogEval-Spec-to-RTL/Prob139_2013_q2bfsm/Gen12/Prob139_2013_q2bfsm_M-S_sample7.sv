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

// y counter and flag
reg y_flag;
reg [1:0] y_count;

assign f = (state == PULSE_F);

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_seq <= 0;
        y_flag <= 0;
        y_count <= 0;
        g <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (resetn) begin
                    state <= PULSE_F;
                end
            end
            PULSE_F: begin
                state <= WAIT_X_SEQUENCE;
                x_seq <= 0;
            end
            WAIT_X_SEQUENCE: begin
                if (x_seq == 0) begin
                    if (x) begin
                        x_seq <= x_seq + 1;
                    end
                end else if (x_seq == 1) begin
                    if (!x) begin
                        x_seq <= x_seq + 1;
                    end else begin
                        x_seq <= 1;
                    end
                end else if (x_seq == 2) begin
                    if (x) begin
                        state <= CONTROL_G;
                        y_count <= 0;
                    end else begin
                        x_seq <= 1;
                    end
                end
            end
            CONTROL_G: begin
                if (!y_flag) begin
                    if (y) begin
                        y_flag <= 1;
                        g <= 1;
                    end else begin
                        y_count <= y_count + 1;
                        if (y_count == 2) begin
                            g <= 0;
                        end
                    end
                end else begin
                    g <= 1;
                end
            end
        endcase
    end
end

endmodule