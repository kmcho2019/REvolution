module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [3:0] bit_pos;  // 0=start, 1-8=data, 9=stop
    reg [7:0] shift_reg;
    reg waiting_for_idle;

    always @(posedge clk) begin
        if (reset) begin
            bit_pos <= 0;
            shift_reg <= 0;
            done <= 0;
            waiting_for_idle <= 0;
        end else begin
            done <= 0;

            if (waiting_for_idle) begin
                if (in) begin
                    waiting_for_idle <= 0;
                    bit_pos <= 0;
                end
            end else begin
                if (bit_pos == 0) begin
                    // Idle state - look for start bit
                    if (!in) begin
                        bit_pos <= 1;  // Start bit detected
                        shift_reg <= 0;  // Clear shift register
                    end
                end else if (bit_pos <= 8) begin
                    // Receiving data bits
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_pos <= bit_pos + 1;
                end else begin
                    // Checking stop bit (bit_pos == 9)
                    if (in) begin
                        done <= 1;  // Valid stop bit
                        bit_pos <= 0;  // Return to idle
                    end else begin
                        waiting_for_idle <= 1;  // Missing stop bit
                    end
                end
            end
        end
    end

endmodule