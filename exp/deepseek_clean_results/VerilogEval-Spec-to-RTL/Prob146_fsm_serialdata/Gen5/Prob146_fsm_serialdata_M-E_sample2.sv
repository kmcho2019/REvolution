module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [9:0] shift_reg;  // [9:8] = state tracking, [7:0] = data bits
    reg [3:0] bit_counter;
    reg capture_flag;

    // Initialize shift register to all 1s (idle state)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b11_1111_1111;
            bit_counter <= 4'd0;
            out_byte <= 8'b0;
            done <= 1'b0;
            capture_flag <= 1'b0;
        end else begin
            // Shift in new bit (LSB first)
            shift_reg <= {shift_reg[8:0], in};

            // Detect start condition (falling edge when idle)
            if (shift_reg[9] && !in) begin
                bit_counter <= 4'd0;
                capture_flag <= 1'b0;
            end else if (!shift_reg[9]) begin
                // Counting 8 data bits after start
                bit_counter <= bit_counter + 1;
            end

            // Check for stop bit condition after 8 data bits
            if (bit_counter == 4'd8) begin
                capture_flag <= in;  // Valid stop bit if in=1
                if (in) begin
                    // Parallel capture of data bits (properly ordered for LSB first)
                    out_byte <= {shift_reg[1], shift_reg[2], shift_reg[3], shift_reg[4],
                                shift_reg[5], shift_reg[6], shift_reg[7], shift_reg[8]};
                end
            end

            // Done signal pulses for one cycle when valid stop bit detected
            done <= (bit_counter == 4'd8) && in && !capture_flag;
        end
    end

endmodule