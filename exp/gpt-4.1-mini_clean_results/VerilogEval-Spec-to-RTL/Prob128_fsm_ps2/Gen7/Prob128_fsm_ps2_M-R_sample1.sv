module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        done = 1'b0;
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2; // BYTE1 just received, move to BYTE2
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                // not used in this encoding, combine BYTE1 & BYTE2 into BYTE2
                next_state = IDLE; // safety fallback (not reached)
            end
            BYTE2: next_state = BYTE3;
            BYTE3: begin
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous reset and output done registered
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is combinational but registered here for timing and sync with state
            if (state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

endmodule