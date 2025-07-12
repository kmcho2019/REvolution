module TopModule (
    input         clk,
    input         in,
    input         reset,
    output reg [7:0] out_byte,
    output reg    done
);

    // One-hot state encoding
    localparam IDLE      = 5'b00001;
    localparam START_BIT = 5'b00010;
    localparam DATA_BITS = 5'b00100;
    localparam STOP_BIT  = 5'b01000;
    localparam WAIT_STOP = 5'b10000;

    reg [4:0] state, next_state;

    reg [2:0] bit_count;       // counts 0 to 7
    reg [7:0] data_reg;

    // State register and synchronous outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    // Nothing to update here, wait for start bit
                end

                START_BIT: begin
                    // If start bit confirmed, reset bit count and data_reg
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_reg <= 8'd0;
                    end
                end

                DATA_BITS: begin
                    // Store the received bit at the bit_count position (LSB first)
                    data_reg[bit_count] <= in;
                    bit_count <= bit_count + 1;
                end

                STOP_BIT: begin
                    // On valid stop bit, latch output and pulse done
                    if (in == 1'b1) begin
                        out_byte <= data_reg;
                        done <= 1'b1;
                    end
                end

                WAIT_STOP: begin
                    // No registers updated except state transition
                end

                default: begin
                    // Should not occur, safe fallback
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                if (in == 1'b0)      // Detected potential start bit
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end

            START_BIT: begin
                if (in == 1'b0)      // Confirm start bit still valid
                    next_state = DATA_BITS;
                else                 // False start bit, return to idle
                    next_state = IDLE;
            end

            DATA_BITS: begin
                if (bit_count == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end

            STOP_BIT: begin
                if (in == 1'b1)      // Valid stop bit: done, go IDLE for next byte
                    next_state = IDLE;
                else                 // Invalid stop bit: enter recovery
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)      // Wait for line to idle (stop bit)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule