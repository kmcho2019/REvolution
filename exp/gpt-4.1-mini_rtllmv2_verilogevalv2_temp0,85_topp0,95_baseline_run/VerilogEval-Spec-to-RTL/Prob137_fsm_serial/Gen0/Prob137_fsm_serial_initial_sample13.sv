module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        STOP = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_count;  // counts from 0 to 7 for 8 bits received

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // default done to 0 each cycle
            case (state)
                IDLE: begin
                    bit_count <= 0;
                end
                RECEIVE: begin
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // done pulse handled in next_state logic below
                end
                WAIT_STOP: begin
                    // no bit_count change
                end
            endcase
        end
    end

    // Next state and done logic combinational
    always @(*) begin
        next_state = state;
        done = 0;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 4'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;  // valid byte received
                    next_state = IDLE;
                end else begin
                    // invalid stop bit, wait for a stop bit
                    next_state = WAIT_STOP;
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

endmodule