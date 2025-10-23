module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);
    // FSM states
    typedef enum reg [1:0] {IDLE=2'b00, RECEIVE=2'b01, STOP_WAIT=2'b10} state_t;
    state_t state, next_state;
    
    reg [3:0] bit_count; // counts 0..7 for 8 bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            done <= 0; // default done to 0 each cycle
            case(state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
                RECEIVE: begin
                    if (bit_count < 7) begin
                        bit_count <= bit_count + 1;
                        state <= RECEIVE;
                    end else if (bit_count == 7) begin
                        // Next bit is stop bit
                        if (in == 1) begin
                            // Correct stop bit
                            done <= 1;
                            state <= IDLE;
                        end else begin
                            // Incorrect stop bit, wait for stop bit 1
                            state <= STOP_WAIT;
                        end
                    end
                end
                STOP_WAIT: begin
                    if (in == 1) begin
                        state <= IDLE;
                    end else begin
                        state <= STOP_WAIT;
                    end
                end
            endcase
        end
    end
endmodule