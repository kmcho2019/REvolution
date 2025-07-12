module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [3:0] counter;  // Counts 0-10 (start + 8 data + stop)
    reg [7:0] data_reg;
    reg waiting_for_idle;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            data_reg <= 0;
            done <= 0;
            waiting_for_idle <= 0;
        end else begin
            done <= 0;

            if (waiting_for_idle) begin
                if (in) begin
                    waiting_for_idle <= 0;
                    counter <= 0;
                end
            end else begin
                if (counter == 0) begin
                    // Start bit detection
                    if (!in) begin
                        counter <= counter + 1;
                    end
                end else if (counter <= 8) begin
                    // Data bits (1-8)
                    data_reg[counter-1] <= in;  // LSB first
                    counter <= counter + 1;
                end else if (counter == 9) begin
                    // Stop bit check
                    if (in) begin
                        done <= 1;
                        counter <= 0;
                    end else begin
                        waiting_for_idle <= 1;
                    end
                end
            end
        end
    end

endmodule