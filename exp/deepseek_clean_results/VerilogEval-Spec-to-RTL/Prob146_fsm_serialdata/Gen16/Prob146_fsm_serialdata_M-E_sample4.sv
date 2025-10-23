module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] bit_pos;  // Counts 0-9 (start + 8 data + stop)
    reg [7:0] data_reg;
    reg prev_in;
    wire start_detected = (prev_in & ~in);  // 1->0 transition

    always @(posedge clk) begin
        if (reset) begin
            bit_pos <= 4'd10;  // Invalid position (idle)
            data_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            prev_in <= 1'b1;
        end else begin
            prev_in <= in;
            done <= 1'b0;

            // Continuous position tracking
            if (bit_pos < 10) begin
                bit_pos <= bit_pos + 1;
                
                // Data capture (bits 1-8)
                if (bit_pos >= 1 && bit_pos <= 8) begin
                    data_reg[bit_pos-1] <= in;  // Direct indexed assignment
                end
                
                // Stop bit check (bit 9)
                if (bit_pos == 9) begin
                    if (in) begin  // Valid stop bit
                        out_byte <= data_reg;
                        done <= 1'b1;
                        bit_pos <= 4'd10;  // Return to idle
                    end
                end
            end
            
            // Start bit detection
            if (start_detected && bit_pos >= 9) begin
                bit_pos <= 0;
            end
            
            // Error recovery - wait for line to return high
            if (bit_pos == 9 && !in) begin
                bit_pos <= bit_pos;  // Hold until stop bit appears
            end
        end
    end

endmodule