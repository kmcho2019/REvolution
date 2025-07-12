module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg state;
reg [1:0] x_counter;
reg [1:0] y_timer;
reg f_pulse;
reg g_set;
wire x_seq_detected;

XSequenceDetector x_seq_detector(
   .clk(clk),
   .resetn(resetn),
   .x(x),
   .detected(x_seq_detected)
);

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_counter <= 0;
        y_timer <= 0;
        f_pulse <= 0;
        f <= 0;
        g <= 0;
        g_set <= 0;
    end else begin
        case (state)
            0: begin
                state <= 1;
                f_pulse <= 1;
                f <= 1;
            end
            1: begin
                state <= 2;
                f_pulse <= 0;
                f <= 0;
            end
            2: begin
                if (x_seq_detected) begin
                    g <= 1;
                    y_timer <= 2;
                end
                if (y_timer > 0) begin
                    if (y) begin
                        g_set <= 1;
                        y_timer <= 0;
                    end else begin
                        y_timer <= y_timer - 1;
                        if (y_timer == 0) begin
                            g <= 0;
                            g_set <= 0;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule

module XSequenceDetector(
    input clk,
    input resetn,
    input x,
    output reg detected
);

reg [1:0] x_state;

always @ (posedge clk) begin
    if (!resetn) begin
        x_state <= 0;
        detected <= 0;
    end else begin
        case (x_state)
            0: begin
                if (x) begin
                    x_state <= 1;
                end
            end
            1: begin
                if (!x) begin
                    x_state <= 2;
                end else begin
                    x_state <= 0;
                end
            end
            2: begin
                if (x) begin
                    x_state <= 0;
                    detected <= 1;
                end else begin
                    x_state <= 0;
                end
            end
        endcase
        if (x_state!= 2) begin
            detected <= 0;
        end
    end
end

endmodule