module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE  = 2'b00, // searching for first byte with in[3]=1
        BYTE2 = 2'b01, // waiting for second byte
        BYTE3 = 2'b10  // waiting for third byte
    } state_t;

    state_t state, next_state;

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // done is only asserted for one cycle after third byte received
            if (state == BYTE3) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE2; // first byte found
                end else begin
                    next_state = IDLE; // keep discarding
                end
            end
            BYTE2: begin
                next_state = BYTE3; // second byte received, go to third
            end
            BYTE3: begin
                next_state = IDLE; // after third byte, return to IDLE
            end
            default: next_state = IDLE;
        endcase
    end

endmodule