module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [1:0] state;
    reg [3:0] bit_count;
    reg [9:0] shift_reg;

    // State definitions
    localparam IDLE = 2'b00;
    localparam RECEIVING = 2'b01;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 10'b0;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            done <= 0;  // Default value

            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVING;
                        shift_reg <= {9'b0, in};  // Store start bit
                        bit_count <= 1;
                    end
                end

                RECEIVING: begin
                    shift_reg <= {shift_reg[8:0], in};  // Shift in new bit

                    if (bit_count == 9) begin  // Received all 10 bits
                        if (shift_reg[9]) begin  // Valid stop bit
                            out_byte <= shift_reg[8:1];  // Capture data
                            done <= 1;
                        end
                        state <= IDLE;
                        bit_count <= 0;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
            endcase
        end
    end

endmodule