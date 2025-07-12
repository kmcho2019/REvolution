// x sequence detector module
module x_sequence_detector(
    input clk,
    input resetn,
    input x,
    output reg x_seq_detected
);
    reg [1:0] x_seq;
    always @ (posedge clk) begin
        if (!resetn) begin
            x_seq <= 0;
            x_seq_detected <= 0;
        end else begin
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
                    x_seq_detected <= 1;
                end else begin
                    x_seq <= 1;
                end
            end
        end
    end
endmodule

// CONTROL_G state module
module control_g(
    input clk,
    input resetn,
    input y,
    input x_seq_detected,
    output reg g,
    output reg y_flag
);
    reg [1:0] y_count;
    always @ (posedge clk) begin
        if (!resetn) begin
            g <= 0;
            y_flag <= 0;
            y_count <= 0;
        end else begin
            if (x_seq_detected) begin
                y_count <= 0;
            end else if (!y_flag) begin
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
    end
endmodule

// TopModule
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
reg [1:0] next_state;

// x sequence detector module
wire x_seq_detected;
x_sequence_detector x_seq_det(
  .clk(clk),
  .resetn(resetn),
  .x(x),
  .x_seq_detected(x_seq_detected)
);

// CONTROL_G state module
wire y_flag;
control_g control_g_module(
  .clk(clk),
  .resetn(resetn),
  .y(y),
  .x_seq_detected(x_seq_detected),
  .g(g),
  .y_flag(y_flag)
);

// State machine
always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (resetn) begin
                    state <= PULSE_F;
                    f <= 1;
                end
            end
            PULSE_F: begin
                state <= WAIT_X_SEQUENCE;
                f <= 0;
            end
            WAIT_X_SEQUENCE: begin
                if (x_seq_detected) begin
                    state <= CONTROL_G;
                end
            end
            CONTROL_G: begin
                // No transition from CONTROL_G
            end
        endcase
    end
end

endmodule