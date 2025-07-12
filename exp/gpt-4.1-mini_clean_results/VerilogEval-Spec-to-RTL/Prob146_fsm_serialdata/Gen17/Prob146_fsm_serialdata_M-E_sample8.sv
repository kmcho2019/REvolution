module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam [1:0]
        IDLE       = 2'b00,
        RECEIVING  = 2'b01,
        WAIT_STOP  = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;      // counts 0 to 7 for data bits
    reg [7:0] shift_reg;

    // Sequential logic: state, bit counter, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, pulse only in specific condition below
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVING: begin
                    // Shift right to receive LSB first, new bit into MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                end

                WAIT_STOP: begin
                    bit_cnt <= 3'd0;
                    // On stop bit correct, pulse done and output byte
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        out_byte <= shift_reg;
                    end
                    // else wait in this state until line returns to idle (1)
                end

                default: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Start bit detected: line goes from idle (1) to 0
                if (in == 1'b0)
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end

            RECEIVING: begin
                if (bit_cnt == 3'd7)
                    next_state = WAIT_STOP;
                else
                    next_state = RECEIVING;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Stop bit OK, back to idle
                else if (in == 1'b0)
                    next_state = WAIT_STOP;  // Wait until line returns to idle
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule