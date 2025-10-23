module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding using typedef enum for clarity
    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;    // Counts number of received data bits (0 to 7)
    reg [7:0] shift_reg;    // Shift register to capture data bits

    // Combinational next state and done signal logic
    logic done_next;

    always_comb begin
        // Default assignments
        next_state = state;
        done_next  = 1'b0;

        case(state)
            IDLE: begin
                if (in == 1'b0)            // Detect start bit (0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin      // Valid stop bit (1)
                    done_next  = 1'b1;     // Assert done one cycle
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP; // Invalid stop bit: wait for next valid stop bit
                end
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

    // Sequential logic: state, bit_count, shift_reg, and done update
    always_ff @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done_next;

            case(state)
                IDLE: begin
                    // Reset counter and shift register only on entering IDLE
                    if (next_state == IDLE) begin
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first:
                    // shift_reg <= {in, shift_reg[7:1]} shifts right and places new bit at MSB.
                    // This aligns with LSB-first sending: first received bit ends in MSB,
                    // last in LSB, which is acceptable since we do not use shift_reg output here.
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    // Clear bit_count and shift_reg preparing for next byte
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                WAIT_STOP: begin
                    // Keep reset bit_count and shift_reg in WAIT_STOP state
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