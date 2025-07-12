module x_sequence_detector(
    input clk,
    input resetn,
    input x,
    output reg sequence_detected
);

reg [1:0] state;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        sequence_detected <= 0;
    end else begin
        case (state)
            0: begin
                if (x) begin
                    state <= 1;
                end
            end
            1: begin
                if (!x) begin
                    state <= 2;
                end else begin
                    state <= 1;
                end
            end
            2: begin
                if (x) begin
                    state <= 0;
                    sequence_detected <= 1;
                end else begin
                    state <= 2;
                end
            end
        endcase
    end
end

endmodule

module y_detector(
    input clk,
    input resetn,
    input y,
    input enable,
    output reg y_detected
);

reg [1:0] counter;

always @ (posedge clk) begin
    if (!resetn) begin
        counter <= 0;
        y_detected <= 0;
    end else if (enable) begin
        if (y) begin
            y_detected <= 1;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2) begin
                y_detected <= 0;
            end
        end
    end else begin
        counter <= 0;
        y_detected <= 0;
    end
end

endmodule

module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg f_pulsed;

x_sequence_detector seq_det(
    .clk(clk),
    .resetn(resetn),
    .x(x),
    .sequence_detected(seq_det_sequence_detected)
);

reg seq_det_sequence_detected;

y_detector y_det(
    .clk(clk),
    .resetn(resetn),
    .y(y),
    .enable(y_det_enable),
    .y_detected(y_det_y_detected)
);

reg y_det_enable;
reg y_det_y_detected;

always @ (posedge clk) begin
    if (!resetn) begin
        f <= 0;
        g <= 0;
        f_pulsed <= 0;
        y_det_enable <= 0;
    end else begin
        if (!f_pulsed) begin
            f <= 1;
            f_pulsed <= 1;
        end else if (seq_det_sequence_detected) begin
            f <= 0;
            y_det_enable <= 1;
        end

        if (y_det_y_detected) begin
            g <= 1;
            y_det_enable <= 0;
        end else if (y_det_enable && !y_det_y_detected) begin
            g <= 0;
        end
    end
end

endmodule