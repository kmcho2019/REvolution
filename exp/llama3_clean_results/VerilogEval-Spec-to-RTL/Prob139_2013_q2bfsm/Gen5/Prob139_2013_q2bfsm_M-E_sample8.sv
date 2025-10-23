module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_count;
reg [1:0] y_count;
reg x_seq_detected;
reg y_detected;

always @ (posedge clk) begin
    if (!resetn) begin
        x_count = 2'b00;
        y_count = 2'b00;
        x_seq_detected = 1'b0;
        y_detected = 1'b0;
        f = 1'b0;
        g = 1'b0;
    end else begin
        if (x_seq_detected == 1'b0) begin
            // Detect 'x' sequence
            case (x_count)
                2'b00: begin
                    if (x) begin
                        x_count = 2'b01;
                    end
                end
                2'b01: begin
                    if (!x) begin
                        x_count = 2'b10;
                    end else begin
                        x_count = 2'b01;
                    end
                end
                2'b10: begin
                    if (x) begin
                        x_count = 2'b00;
                        x_seq_detected = 1'b1;
                        f = 1'b1;
                    end else begin
                        x_count = 2'b01;
                    end
                end
            endcase
        end else begin
            // Monitor 'y' signal
            if (y_detected == 1'b0) begin
                if (y) begin
                    y_detected = 1'b1;
                    g = 1'b1;
                end else if (y_count == 2'b10) begin
                    g = 1'b0;
                    y_detected = 1'b1;
                end
                y_count = y_count + 1;
            end
        end
    end
    if (x_seq_detected && y_detected) begin
        f = 1'b0;
    end
end

endmodule