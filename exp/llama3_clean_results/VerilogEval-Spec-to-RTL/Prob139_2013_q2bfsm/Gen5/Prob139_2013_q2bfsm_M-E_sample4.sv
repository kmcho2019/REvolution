module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] seq_counter;
reg y_counter;
reg seq_detected;
reg g_set;

always @ (posedge clk) begin
    if (!resetn) begin
        seq_counter <= 0;
        y_counter <= 0;
        seq_detected <= 0;
        g_set <= 0;
        f <= 0;
        g <= 0;
    end else begin
        if (seq_detected == 0) begin
            // Sequence detection
            case (seq_counter)
                0: begin
                    if (x) seq_counter <= 1;
                end
                1: begin
                    if (!x) seq_counter <= 2;
                    else seq_counter <= 1;
                end
                2: begin
                    if (x) begin
                        seq_detected <= 1;
                        seq_counter <= 0;
                    end else seq_counter <= 0;
                end
            endcase
        end

        // Set f to 1 for one clock cycle after reset
        if (seq_detected == 0 && resetn) begin
            f <= 1;
            seq_detected <= 1;
        end else if (seq_detected == 1 && f == 1) begin
            f <= 0;
        end

        // Monitor y and set g
        if (g_set == 0) begin
            if (y_counter == 0) begin
                y_counter <= y_counter + 1;
                if (y) begin
                    g <= 1;
                    g_set <= 1;
                end
            end else if (y_counter == 1) begin
                y_counter <= y_counter + 1;
                if (y) begin
                    g <= 1;
                    g_set <= 1;
                end else g <= 0;
            end
        end
    end
end

endmodule