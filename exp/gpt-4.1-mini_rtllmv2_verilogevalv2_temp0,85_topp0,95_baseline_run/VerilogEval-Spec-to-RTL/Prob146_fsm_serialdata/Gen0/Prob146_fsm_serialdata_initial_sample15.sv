module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        STOP = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_count; // count 0 to 7 for data bits
    reg [7:0] data_shift;

    // Detect start bit on line going from 1 to 0
    reg in_dly;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'b0;
            out_byte <= 8'b0;
            done <= 0;
            in_dly <= 1'b1; // line idle is 1
        end else begin
            in_dly <= in;
            done <= 0; // default done low

            state <= next_state;

            case(state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 8'b0;
                    if (in_dly == 1 && in == 0) begin
                        // start bit detected (falling edge)
                        // move to receive data bits
                        bit_count <= 0;
                    end
                end
                RECEIVE: begin
                    // shift in data bit LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // nothing to do here except wait for state update
                end
                WAIT_STOP: begin
                    // wait until line is 1 (stop bit)
                end
            endcase

            // output byte and done are updated in state transitions below
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in_dly == 1 && in == 0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 8)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1) begin
                    // stop bit correct
                    next_state = IDLE;
                end else begin
                    // stop bit incorrect, go wait for stop bit to appear
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
        endcase
    end

    // Output logic on state transitions
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 0;
            done <= 0;
        end else begin
            if (state == STOP && next_state == IDLE && in == 1) begin
                // stop bit correct, output byte and assert done
                out_byte <= data_shift;
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

endmodule