module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // State encoding (one-hot style for clarity)
    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        START      = 3'd1,
        DATA       = 3'd2,
        STOP_CHECK = 3'd3,
        ERROR_WAIT = 3'd4
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_index;  // counts 0 to 7 for data bits

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_index <= 3'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default no done asserted

            case (state)
                IDLE: begin
                    // Wait for start bit low
                    // Nothing to do here; waiting for START state
                end

                START: begin
                    // Confirm start bit stable low; no registers needed here
                    // Shift reg and counters reset handled in next_state logic
                end

                DATA: begin
                    // Shift in input bit LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_index <= bit_index + 1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        // Correct stop bit, output byte and assert done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end

                ERROR_WAIT: begin
                    // Wait for line to go back to idle (1)
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Confirm start bit still 0
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // false start bit or glitch
            end

            DATA: begin
                if (bit_index == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = DATA;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule