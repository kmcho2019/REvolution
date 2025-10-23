module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_state;
reg [1:0] y_state;
reg x_sequence_detected;
reg y_timeout;

always @ (posedge clk) begin
    if (!resetn) begin
        x_state <= 0;
        y_state <= 0;
        f <= 0;
        g <= 0;
        x_sequence_detected <= 0;
        y_timeout <= 0;
    end else begin
        // Sequence detector for 'x'
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
                    x_state <= 1;
                end
            end
            2: begin
                if (x) begin
                    x_sequence_detected <= 1;
                    x_state <= 0;
                end else begin
                    x_state <= 2;
                end
            end
        endcase

        // Controller for 'y' and output 'g'
        if (x_sequence_detected) begin
            y_state <= 1;
            x_sequence_detected <= 0;
            f <= 0;
            g <= 1;
        end

        case (y_state)
            1: begin
                if (y) begin
                    y_state <= 2;
                    g <= 1;
                end else begin
                    y_timeout <= y_timeout + 1;
                    if (y_timeout == 2) begin
                        g <= 0;
                        y_state <= 0;
                    end
                end
            end
            2: begin
                g <= 1;
            end
        endcase

        // Set 'f' high for one clock cycle after reset
        if (!resetn && x_sequence_detected) begin
            f <= 1;
        end else begin
            f <= 0;
        end

        // Reset 'y_timeout' when 'y' becomes high or timeout occurs
        if (y || (y_timeout == 2)) begin
            y_timeout <= 0;
        end
    end
end

endmodule