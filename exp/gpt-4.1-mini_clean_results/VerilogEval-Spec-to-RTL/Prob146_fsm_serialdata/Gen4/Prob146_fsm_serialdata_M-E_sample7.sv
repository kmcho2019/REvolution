module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    typedef enum logic [2:0] {
        IDLE       = 3'd0,
        START_WAIT = 3'd1,
        RECEIVE    = 3'd2,
        STOP_CHECK = 3'd3,
        WAIT_STOP  = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;      // Counts received data bits 0..7
    reg [7:0] shift_reg;    // Shift register for incoming data bits
    reg       in_dly;       // input delayed one cycle for start bit confirmation

    // Sequential block: state and data registers
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
            in_dly    <= 1'b1;  // line idle high at start
        end else begin
            in_dly <= in;       // sample input

            state <= next_state;
            done  <= 1'b0;      // default done low

            case (state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START_WAIT: begin
                    // Wait to confirm start bit stable low
                end

                RECEIVE: begin
                    // Shift in LSB first (shift right)
                    // Shift register: incoming bit in MSB, shift right for LSB first
                    // Actually, input bit is LSB first, so shift right and place 'in' in MSB or
                    // shift left and put in LSB? 
                    // To receive LSB first: shift right and put bit at MSB or shift left and put bit at LSB
                    // Let's shift right and put incoming bit into MSB for each new bit:
                    // Then after all bits received, bit 0 is shift_reg[0].
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt   <= bit_cnt + 1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;  // pulse done
                    end
                end

                WAIT_STOP: begin
                    // Hold until stop bit (in==1)
                end

                default: ;
            endcase
        end
    end

    // Combinational block: next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                // Idle line is 1. Start bit indicated by input == 0.
                if (in == 1'b0)
                    next_state = START_WAIT;
                else
                    next_state = IDLE;
            end

            START_WAIT: begin
                // Confirm start bit stable low for one full clock cycle
                // in_dly samples input in previous cycle
                if ((in == 1'b0) && (in_dly == 1'b0)) begin
                    next_state = RECEIVE;
                end else begin
                    // Noise or glitch: return to idle
                    next_state = IDLE;
                end
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Valid stop bit, restart idle for next byte
                else
                    next_state = WAIT_STOP; // Invalid stop bit, wait for line to become 1
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule