module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized state encoding
    localparam IDLE   = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state;
    reg [3:0] cycle_count;  // Counts 0-8 (0=start, 1-8=data, 9=stop)
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cycle_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default value

            case (state)
                IDLE: begin
                    if (in == 0) begin  // Start bit detected
                        state <= ACTIVE;
                        cycle_count <= 0;
                        shift_reg <= 0;
                    end
                end

                ACTIVE: begin
                    if (cycle_count < 8) begin
                        // Shift in data bits (LSB first)
                        shift_reg <= {in, shift_reg[7:1]};
                    end
                    
                    if (cycle_count == 8) begin  // Stop bit cycle
                        if (in == 1) begin  // Valid stop bit
                            out_byte <= shift_reg;
                            done <= 1;
                        end
                        state <= IDLE;  // Return to IDLE regardless of stop bit
                    end
                    
                    cycle_count <= cycle_count + 1;
                end
            endcase
        end
    end

endmodule