module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg reset_deasserted;
reg x_seq_detected;
reg y_detected;
reg [1:0] x_count;
reg [1:0] y_count;

// Reset Controller
always @ (posedge clk) begin
    if (!resetn) begin
        reset_deasserted <= 0;
        f <= 0;
        g <= 0;
    end else if (!reset_deasserted) begin
        reset_deasserted <= 1;
        f <= 1;
    end else begin
        f <= 0;
    end
end

// X-Sequence Detector
always @ (posedge clk) begin
    if (resetn && reset_deasserted) begin
        if (x_seq_detected) begin
            x_seq_detected <= 0;
        end else if (x_count == 0 && x) begin
            x_count <= 1;
        end else if (x_count == 1 && !x) begin
            x_count <= 2;
        end else if (x_count == 2 && x) begin
            x_seq_detected <= 1;
            x_count <= 0;
        end else if (x_count != 0) begin
            x_count <= 0;
        end
    end else begin
        x_seq_detected <= 0;
        x_count <= 0;
    end
end

// Y-Detection Module
always @ (posedge clk) begin
    if (resetn && x_seq_detected) begin
        if (y_detected) begin
            // No action
        end else if (y) begin
            y_detected <= 1;
            g <= 1;
        end else begin
            y_count <= y_count + 1;
            if (y_count == 2) begin
                y_detected <= 1;
                g <= 0;
            end
        end
    end else begin
        y_detected <= 0;
        y_count <= 0;
        g <= 0;
    end
end

endmodule