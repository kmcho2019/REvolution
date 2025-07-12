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

    reg [2:0] bit_count;  // counts number of received data bits (0 to 7)
    reg [7:0] data_reg;   // store received data bits, LSB first

    // Next state logic - purely combinational
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit = 0
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, move to STOP_WAIT
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end

            STOP_WAIT: begin
                // Wait for stop bit = 1 before returning to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, bit count, data shift, done signal
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done de-asserted each cycle

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    // wait for start bit
                end

                RECEIVE: begin
                    // Shift data_reg left by 1, input bit goes to LSB (LSB first)
                    // So new bit is data_reg[0], then shift left
                    data_reg <= {in, data_reg[7:1]}; // original code shifted right, reversed bits; now shift left

                    if (bit_count < 3'd7)
                        bit_count <= bit_count + 1'b1;
                end

                STOP_WAIT: begin
                    // Assert done for one clock cycle when stop bit (1) received
                    if (in == 1'b1)
                        done <= 1'b1;
                    // else keep waiting in STOP_WAIT, done remains 0
                end

                default: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule