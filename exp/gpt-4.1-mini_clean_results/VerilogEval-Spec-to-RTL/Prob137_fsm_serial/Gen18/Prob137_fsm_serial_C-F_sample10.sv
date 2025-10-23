module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states encoded in 2 bits
    localparam IDLE       = 2'd0,
               RECEIVE    = 2'd1,
               CHECK_STOP = 2'd2,
               WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;   // Counts data bits received [0..7]
    reg [7:0] shift_reg;   // Shift register for 8 data bits (LSB first)

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 data bits, check stop bit
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                // Valid stop bit => back to IDLE; else error recovery
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Stay until stop bit (1) detected
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift register, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done deasserted each cycle; pulse generated only on valid stop bit
            done <= 1'b0;

            case(state)
                IDLE: begin
                    // Clear counters and shift reg to stable known state in IDLE
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Enable update only during RECEIVE to reduce toggling
                    shift_reg <= {shift_reg[6:0], in}; // Shift left, insert new bit at LSB (LSB first)
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // Check stop bit validity
                    if (in == 1'b1)
                        done <= 1'b1;  // Pulse done on valid stop bit
                    // Reset bit counter to prepare for next frame
                    bit_count <= 3'd0;
                    // shift_reg not cleared here to keep last received byte if needed
                end

                WAIT_STOP: begin
                    // Wait for valid stop bit - hold counters and shift register reset
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule