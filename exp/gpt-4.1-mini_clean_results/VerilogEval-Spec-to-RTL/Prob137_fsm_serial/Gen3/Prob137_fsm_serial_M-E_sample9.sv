module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE       = 3'd0;
    localparam START      = 3'd1;
    localparam RECEIVE    = 3'd2;
    localparam STOP_CHECK = 3'd3;
    localparam ERROR_WAIT = 3'd4;

    reg [2:0] state, next_state;

    reg [2:0] bit_counter;       // Counts 0 to 7 for 8 data bits
    reg [7:0] shift_reg;         // Shift register for data bits (LSB first)

    // State transition (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            bit_counter <= 3'd0;
            shift_reg   <= 8'd0;
            done        <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            case(state)
                START: begin
                    // Start bit confirmed (in==0), prepare to receive data bits
                    bit_counter <= 3'd0;
                    shift_reg   <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in current bit on rising edge; LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_counter <= bit_counter + 3'd1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // Valid stop bit, pulse done
                    end
                end

                ERROR_WAIT: begin
                    // wait for line to go idle (1)
                    // no counters updated here
                end

                default: begin
                    bit_counter <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START; // detect start bit
                else
                    next_state = IDLE;
            end

            START: begin
                // After confirming start bit, move to RECEIVE
                next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_counter == 3'd7)
                    next_state = STOP_CHECK; // after 8 bits, check stop
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit, ready for next byte
                else
                    next_state = ERROR_WAIT; // framing error, wait for idle
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE; // recovered, back to idle
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule