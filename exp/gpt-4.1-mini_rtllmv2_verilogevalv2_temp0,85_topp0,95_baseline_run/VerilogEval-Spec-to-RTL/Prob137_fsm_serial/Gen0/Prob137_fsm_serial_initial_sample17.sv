module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'd0,
        RECEIVE = 2'd1,
        WAIT_STOP = 2'd2
    } state_t;
    
    state_t state, next_state;
    reg [3:0] bit_count; // counts up to 8
    
    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done
            case(state)
                IDLE: begin
                    bit_count <= 4'd0;
                    // nothing else to do
                end
                RECEIVE: begin
                    bit_count <= bit_count + 4'd1;
                end
                WAIT_STOP: begin
                    // nothing to count here
                end
            endcase
        end
    end
    
    // Next state logic and done output
    always @(*) begin
        next_state = state;
        done = 1'b0;
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end else begin
                    next_state = IDLE;
                end
            end
            RECEIVE: begin
                // After receiving 8 bits, expect stop bit
                if (bit_count == 4'd7) begin
                    // After this clock, 8th bit received, next is stop bit
                    // But stop bit check happens on next cycle
                    next_state = WAIT_STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            WAIT_STOP: begin
                // Check stop bit (should be 1)
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // stay here until stop bit is seen
                    next_state = WAIT_STOP;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule