module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Enumerated FSM states
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP       = 2'd2,
        ERROR_WAIT = 2'd3
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Sequential block: state, counters, shift_reg, out_byte, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;

            // Default done low each cycle
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    // Reset shift_reg only when entering IDLE to reduce toggling
                    if (next_state == IDLE)
                        shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first: shift right, new bit into MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt   <= bit_cnt + 3'd1;
                end

                STOP: begin
                    // bit_cnt reset here to 0 for next frame
                    bit_cnt <= 3'd0;

                    if (in == 1'b1) begin
                        done     <= 1'b1;
                        out_byte <= shift_reg;
                    end
                end

                ERROR_WAIT: begin
                    bit_cnt <= 3'd0;
                    // Hold shift_reg stable to reduce toggling
                    shift_reg <= shift_reg;
                end

                default: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next state logic (Moore machine style)
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE:
                next_state = (bit_cnt == 3'd7) ? STOP : RECEIVE;

            STOP:
                next_state = (in == 1'b1) ? IDLE : ERROR_WAIT;

            ERROR_WAIT:
                next_state = (in == 1'b1) ? IDLE : ERROR_WAIT;

            default:
                next_state = IDLE;
        endcase
    end

endmodule