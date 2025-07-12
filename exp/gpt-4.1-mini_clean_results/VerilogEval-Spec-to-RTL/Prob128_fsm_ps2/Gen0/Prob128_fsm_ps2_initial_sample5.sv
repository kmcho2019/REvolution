module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE2          = 2'b01,
        BYTE3          = 2'b10
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is only asserted for one clock after third byte received
            done <= (state == BYTE3);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WAIT_FOR_START: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = WAIT_FOR_START;
            end
            default: next_state = WAIT_FOR_START;
        endcase
    end

endmodule