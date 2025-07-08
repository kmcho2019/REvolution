module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE      = 3'b000,
        START_BIT = 3'b001,
        DATA_BITS = 3'b010,
        STOP_BIT  = 3'b011,
        WAIT_STOP = 3'b100
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_count; // to count 8 data bits
    reg [7:0] data_reg;  // to hold received data bits, though not used for output here

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low, pulse one clk when byte received

            case (state)
                START_BIT: begin
                    // Confirm start bit, no data captured
                    if (in == 1'b0) begin
                        bit_count <= 0;
                    end
                end

                DATA_BITS: begin
                    // Shift in the data bits LSB first
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP_BIT: begin
                    // Nothing to do on data_reg here; done asserted in next_state logic
                end

                default: begin
                    // no data_reg or bit_count update
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                done = 1'b0;
                if (in == 1'b0) // start bit detected
                    next_state = START_BIT;
            end

            START_BIT: begin
                if (in == 1'b0) 
                    next_state = DATA_BITS;
                else
                    next_state = IDLE; // False start bit, line went back to idle
            end

            DATA_BITS: begin
                if (bit_count == 4'd7) // 8 bits received (count 0..7)
                    next_state = STOP_BIT;
            end

            STOP_BIT: begin
                if (in == 1'b1) begin
                    done = 1'b1; // correctly received byte
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP; // wait until stop bit arrives
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // recovered line, back to idle waiting start bit
            end

            default: next_state = IDLE;
        endcase
    end

endmodule