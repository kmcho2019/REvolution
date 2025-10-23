module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_counter;
reg [1:0] y_counter;
reg x_sequence_detected;
reg y_detected;

always @(posedge clk) begin
    if (!resetn) begin
        x_counter <= 0;
        y_counter <= 0;
        x_sequence_detected <= 0;
        y_detected <= 0;
        f <= 0;
        g <= 0;
    end else begin
        if (!x_sequence_detected) begin
            if (x_counter == 0) begin
                if (x) begin
                    x_counter <= x_counter + 1;
                end
            end else if (x_counter == 1) begin
                if (!x) begin
                    x_counter <= x_counter + 1;
                end else begin
                    x_counter <= 0;
                end
            end else if (x_counter == 2) begin
                if (x) begin
                    x_sequence_detected <= 1;
                    x_counter <= 0;
                end else begin
                    x_counter <= 0;
                end
            end
        end

        if (x_sequence_detected && !y_detected) begin
            if (y_counter == 0) begin
                f <= 1;
            end else if (y_counter == 1) begin
                f <= 0;
            end
            y_counter <= y_counter + 1;

            if (y) begin
                g <= 1;
                y_detected <= 1;
            end else if (y_counter == 2) begin
                g <= 0;
                y_detected <= 1;
            end
        end
    end
end

endmodule