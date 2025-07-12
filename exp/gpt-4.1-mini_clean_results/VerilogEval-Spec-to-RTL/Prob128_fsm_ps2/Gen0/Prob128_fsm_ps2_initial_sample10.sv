module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);
    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    // Sequential logic for state and done output
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is asserted only when transitioning from BYTE3 to IDLE
            done <= (state == BYTE3);
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule