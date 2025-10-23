module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [1:0] {IDLE=2'd0, RECEIVE=2'd1, STOP_WAIT=2'd2} state_t;
    state_t state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        done = 1'b0; // Default done low unless set in sequential
        case(state)
            IDLE: 
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            RECEIVE:
                if (bit_cnt == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            STOP_WAIT:
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        if (bit_cnt == 3'd7) begin
                            // Valid stop bit and complete byte received
                            out_byte <= shift_reg;
                            done <= 1'b1;
                        end
                        bit_cnt <= 3'd0; // Reset bit count for next byte
                        shift_reg <= 8'd0; // Clear shift register
                    end
                    // else remain in STOP_WAIT, no done asserted
                end
            endcase
        end
    end

endmodule