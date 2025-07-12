module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // States encoding
    localparam [1:0]
        IDLE       = 2'd0,
        RECEIVING  = 2'd1,
        STOP_BIT   = 2'd2,
        ERROR_WAIT = 2'd3;

    reg [1:0] state, next_state;

    reg [7:0] data_reg;      // shift register for received bits (LSB first)
    reg [3:0] bit_count;     // counts received bits 0..8 (using 4 bits for safe counting)

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low each cycle

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_reg <= 8'b0;
                end

                RECEIVING: begin
                    // Shift in new bit at MSB, shifting data right by 1:
                    // Since LSB is sent first, shifting right places new bit at MSB
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP_BIT: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // Byte successfully received
                    end
                    // bit_count and data_reg remain unchanged here
                end

                ERROR_WAIT: begin
                    // Wait for line to return to high before next byte
                    // No register updates needed here
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit = 0
                if (in == 1'b0)
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end

            RECEIVING: begin
                // After 8 bits received, go to STOP_BIT
                if (bit_count == 8)
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVING;
            end

            STOP_BIT: begin
                if (in == 1'b1)
                    next_state = IDLE;        // Correct stop bit, ready for next byte
                else
                    next_state = ERROR_WAIT;  // Invalid stop bit, wait for stop bit
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