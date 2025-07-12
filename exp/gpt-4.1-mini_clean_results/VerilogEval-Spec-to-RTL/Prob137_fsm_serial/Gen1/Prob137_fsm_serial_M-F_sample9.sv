module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        STOP_WAIT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;  // counts 0 to 7 data bits received
    reg [7:0] data_reg;   // to store data bits (LSB first)

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end
            STOP_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT; // wait for valid stop bit
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0 each cycle; assert done only when stop bit verified
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    // done <= 0; // already assigned above
                end
                RECEIVE: begin
                    // Shift in data bit LSB first: shift left, insert 'in' at bit 0
                    // After 8 cycles, data_reg holds the byte with first received bit at bit 0
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP_WAIT: begin
                    // When stop bit detected correctly, assert done for one cycle
                    if (in == 1'b1)
                        done <= 1'b1;
                    // else done stays 0, wait for valid stop bit
                end
                default: begin
                    // Should not occur
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule