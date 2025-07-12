module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [9:0] shift_reg;  // Stores start + 8 data + stop bits
    reg [3:0] bit_count;  // Counts 0-9 (10 bits total)
    reg last_in;          // For edge detection
    wire start_detected;

    // Falling edge detection (1->0 transition)
    assign start_detected = last_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b0;
            bit_count <= 4'b0;
            done <= 1'b0;
            last_in <= 1'b1;
        end else begin
            last_in <= in;
            done <= 1'b0;  // Default to not done

            if (bit_count == 4'd0) begin
                // Idle state - waiting for start bit
                if (start_detected) begin
                    shift_reg <= {shift_reg[8:0], in};
                    bit_count <= bit_count + 1;
                end
            end else if (bit_count < 4'd10) begin
                // Receiving bits
                shift_reg <= {shift_reg[8:0], in};
                bit_count <= bit_count + 1;
            end else begin
                // Full frame received - validate
                if (shift_reg[9] == 1'b0 && shift_reg[0] == 1'b1) begin
                    done <= 1'b1;  // Valid frame: start=0, stop=1
                end
                // Prepare for next frame
                bit_count <= 4'b0;
                shift_reg <= 10'b0;
            end
        end
    end

endmodule