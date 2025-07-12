module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam IDLE        = 2'd0,
               RECEIVE_BITS= 2'd1,
               WAIT_STOP   = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE_BITS: begin
                    // Shift in LSB first (new bit into MSB)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                end

                WAIT_STOP: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b1) begin
                        // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                // Wait for start bit (0)
                next_state = (in == 1'b0) ? RECEIVE_BITS : IDLE;

            RECEIVE_BITS:
                // After 8 bits, check stop bit
                next_state = (bit_cnt == 3'd7) ? WAIT_STOP : RECEIVE_BITS;

            WAIT_STOP:
                // If stop bit valid (1), return to IDLE
                // Else remain until line idle (1)
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            default:
                next_state = IDLE;
        endcase
    end

endmodule