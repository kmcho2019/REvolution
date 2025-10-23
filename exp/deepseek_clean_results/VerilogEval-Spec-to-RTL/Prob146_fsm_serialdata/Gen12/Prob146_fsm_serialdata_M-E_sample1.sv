module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [8:0] shift_reg;  // [8] = stop bit, [7:0] = data (LSB first)
    reg [3:0] bit_count;  // Counts 0-8 (start + 8 data bits)

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 9'b1_1111_1111;  // Idle state (all 1s)
            bit_count <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default to 0, pulse when byte complete
            
            if (shift_reg[8]) begin  // Idle state (stop bit position is 1)
                if (!in) begin  // Start bit detected
                    shift_reg <= {8'b1111_1111, in};  // Initialize with start bit
                    bit_count <= 1;
                end
            end else begin  // Receiving data
                if (bit_count < 9) begin
                    shift_reg <= {shift_reg[7:0], in};  // Shift left (LSB first)
                    bit_count <= bit_count + 1;
                end
                
                // Check for complete byte (9 bits received)
                if (bit_count == 9) begin
                    if (shift_reg[8]) begin  // Valid stop bit
                        out_byte <= shift_reg[7:0];
                        done <= 1;
                        shift_reg <= 9'b1_1111_1111;  // Return to idle
                    end else begin
                        // Invalid stop bit - wait for next 1
                        shift_reg <= {shift_reg[7:0], in};
                    end
                    bit_count <= 0;
                end
            end
        end
    end

endmodule