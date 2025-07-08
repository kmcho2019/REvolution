module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        STOP_WAIT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_count;  // to count 8 bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // default done = 0 unless set below
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count <= 4'd0;
                    // wait for start bit
                    // no done output here
                end
                RECEIVE: begin
                    bit_count <= bit_count + 1'b1;
                end
                STOP_WAIT: begin
                    // wait for stop bit (in == 1)
                    // no bit_count increment here
                end
            endcase

            // done is asserted in next_state logic below
            // but it must be registered output, so done = 1 one cycle after receiving stop bit
            if (state == RECEIVE && bit_count == 4'd8) begin
                if (in == 1'b1) begin
                    // Correct stop bit detected - done signal for one cycle
                    done <= 1'b1;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // line idle is 1
                // start bit is 0
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 4'd8) begin
                    // After 8 data bits, check stop bit
                    if (in == 1'b1)
                        next_state = IDLE; // byte done correctly
                    else
                        next_state = STOP_WAIT; // wait until stop bit appears
                end else begin
                    next_state = RECEIVE;
                end
            end
            STOP_WAIT: begin
                // wait for stop bit (in == 1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule