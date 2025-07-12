module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [9:0] shift_reg;  // [9] is first received bit (start), [0] is last (stop)
    reg [3:0] bit_count;  // Counts 0-9 (10 bits total)
    reg last_in;          // For edge detection
    reg [1:0] state;      // State machine

    // States
    localparam IDLE     = 2'b00;
    localparam RECEIVING = 2'b01;
    localparam VALIDATE = 2'b10;
    localparam ERROR    = 2'b11;

    // Falling edge detection (1->0 transition)
    wire start_detected = (last_in & ~in);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b0;
            bit_count <= 4'b0;
            done <= 1'b0;
            last_in <= 1'b1;
            state <= IDLE;
        end else begin
            last_in <= in;
            done <= 1'b0;  // Default to not done

            case (state)
                IDLE: begin
                    if (start_detected) begin
                        shift_reg <= {in, shift_reg[9:1]};  // Shift right, MSB first
                        bit_count <= 4'd1;
                        state <= RECEIVING;
                    end
                end

                RECEIVING: begin
                    shift_reg <= {in, shift_reg[9:1]};  // Continue shifting right
                    bit_count <= bit_count + 1;

                    if (bit_count == 4'd9) begin  // Received all 10 bits
                        state <= VALIDATE;
                    end
                end

                VALIDATE: begin
                    if (shift_reg[9] == 1'b0 && shift_reg[0] == 1'b1) begin
                        done <= 1'b1;  // Valid frame
                        state <= IDLE;
                    end else begin
                        state <= ERROR;  // Invalid frame
                    end
                end

                ERROR: begin
                    if (in == 1'b1) begin  // Wait for line to return to idle (1)
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule