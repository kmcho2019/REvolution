module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // States for the FSM
    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2,
        BYTE3 = 2'd3
    } state_t;

    reg [1:0] state, next_state;

    // State register with synchronous active high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for first byte with in[3] = 1
                if (in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                // After receiving first byte, next byte is second byte
                next_state = BYTE2;
            end
            BYTE2: begin
                // After second byte, next byte is third byte
                next_state = BYTE3;
            end
            BYTE3: begin
                // After third byte, go back to IDLE to find next message start
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // done signal generation: one clock cycle immediately after receiving third byte
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= (state == BYTE3);
    end

endmodule