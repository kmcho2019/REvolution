module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE1_RECEIVED = 2'b01,
        BYTE2_RECEIVED = 2'b10,
        BYTE3_RECEIVED = 2'b11
    } state_t;

    state_t state, next_state;

    // Sequential state update and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is asserted only when transitioning from BYTE3_RECEIVED to WAIT_FOR_START
            done <= (state == BYTE3_RECEIVED);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: begin
                if (in[3] == 1'b1)
                    next_state = BYTE1_RECEIVED;
                else
                    next_state = WAIT_FOR_START;
            end
            BYTE1_RECEIVED: next_state = BYTE2_RECEIVED;
            BYTE2_RECEIVED: next_state = BYTE3_RECEIVED;
            BYTE3_RECEIVED: next_state = WAIT_FOR_START;
            default: next_state = WAIT_FOR_START;
        endcase
    end

endmodule