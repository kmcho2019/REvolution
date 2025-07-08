module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        DATA = 2'b01,
        STOP = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_count;  // to count 8 bits
    reg [7:0] data_shift;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // default done low, asserted only in STOP on correct stop bit

            case(state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 0;
                    // wait for start bit = 0
                end
                DATA: begin
                    // shift in the current bit at LSB (LSB first)
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // done is asserted here for one cycle if stop bit correct
                    if (in == 1) begin
                        done <= 1;
                    end
                end
                WAIT_STOP: begin
                    // wait until in==1 to return to IDLE
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 0) 
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 8)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule