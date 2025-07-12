module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [7:0] shift_reg;
    reg [3:0] bit_counter;  // Counts 0-9 (start + 8 bits + stop)
    reg receiving;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            bit_counter <= 4'b0;
            receiving <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default to not done
            
            if (receiving) begin
                // Shift in data (LSB first)
                shift_reg <= {in, shift_reg[7:1]};
                
                if (bit_counter == 4'd9) begin
                    // Check stop bit
                    if (in) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    receiving <= 1'b0;
                    bit_counter <= 4'b0;
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end else begin
                // IDLE state - wait for start bit
                if (~in) begin
                    receiving <= 1'b1;
                    bit_counter <= 4'd1;  // Skip start bit
                end
            end
        end
    end

endmodule