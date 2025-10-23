module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [2:0] bit_pos;  // 0=start, 1-8=data, 9=stop (3 bits sufficient)
    reg [7:0] shift_reg;
    reg in_idle_state;

    always @(posedge clk) begin
        if (reset) begin
            bit_pos <= 0;
            shift_reg <= 0;
            done <= 0;
            in_idle_state <= 1;
        end else begin
            done <= 0;

            if (in_idle_state) begin
                if (!in) begin
                    // Start bit detected
                    bit_pos <= 1;
                    shift_reg <= 0;
                    in_idle_state <= 0;
                end
            end else begin
                case (bit_pos)
                    0: begin  // Shouldn't normally reach here
                        in_idle_state <= 1;
                    end
                    1,2,3,4,5,6,7,8: begin
                        // Receiving data bits (LSB first)
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_pos <= bit_pos + 1;
                    end
                    9: begin
                        // Checking stop bit
                        if (in) begin
                            done <= 1;  // Valid stop bit
                        end
                        in_idle_state <= 1;  // Return to idle
                        bit_pos <= 0;
                    end
                    default: begin
                        in_idle_state <= 1;
                        bit_pos <= 0;
                    end
                endcase
            end
        end
    end

endmodule