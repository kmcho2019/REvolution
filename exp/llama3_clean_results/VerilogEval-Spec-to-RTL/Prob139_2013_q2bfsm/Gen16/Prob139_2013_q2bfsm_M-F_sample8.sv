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
                    x_seq <= 0;
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
    output reg g
);
    reg y_count;
    reg detected;
    always @ (posedge clk) begin
        if (!resetn) begin
            g <= 0;
            y_count <= 0;
            detected <= 0;
        end else begin
            if (x_seq_detected && !detected) begin
                y_count <= 1;
                detected <= 1;
            end else if (detected) begin
                if (y) begin
                    g <= 1;
                end else if (y_count == 2) begin
                    g <= 0;
                end else begin
                    y_count <= y_count + 1;
                end
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
reg [1:0] state;

// x sequence detector module
wire x_seq_detected;
x_sequence_detector x_seq_det(
  .clk(clk),
  .resetn(resetn),
  .x(x),
  .x_seq_detected(x_seq_detected)
);

// CONTROL_G state module
control_g control_g_module(
  .clk(clk),
  .resetn(resetn),
  .y(y),
  .x_seq_detected(x_seq_detected),
  .g(g)
);

// State machine
always @ (posedge clk) begin
    if (!resetn) begin
        state <= 2'b00;
        f <= 0;
    end else begin
        case (state)
            2'b00: begin
                if (resetn) begin
                    state <= 2'b01;
                    f <= 1;
                end
            end
            2'b01: begin
                state <= 2'b10;
                f <= 0;
            end
            2'b10: begin
                if (x_seq_detected) begin
                    state <= 2'b11;
                end
            end
            2'b11: begin
                // No transition from 2'b11
            end
        endcase
    end
end

endmodule