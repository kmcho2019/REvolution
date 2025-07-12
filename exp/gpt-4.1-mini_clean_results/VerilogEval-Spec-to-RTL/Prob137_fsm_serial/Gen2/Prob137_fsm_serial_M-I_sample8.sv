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
    reg [3:0] bit_count;     // counts received bits 0..8 (4 bits for safe counting)

    // State register and data capture
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
                    // Shift in new bit at LSB, shifting data left by 1:
                    // Because LSB sent first, first bit goes to data_reg[0]
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP_BIT: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // Byte successfully received, pulse done
                    end
                    // bit_count and data_reg remain unchanged
                end

                ERROR_WAIT: begin
                    // Wait for line to return high (stop bit)
                    // No register changes here
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end

            RECEIVING: begin
                if (bit_count == 8)
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVING;
            end

            STOP_BIT: begin
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