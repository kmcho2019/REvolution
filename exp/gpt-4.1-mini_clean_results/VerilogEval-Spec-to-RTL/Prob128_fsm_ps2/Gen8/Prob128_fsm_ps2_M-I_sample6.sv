module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        WAIT_START = 2'd0,
        BYTE2      = 2'd1,
        BYTE3      = 2'd2
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        done = 1'b0;
        case (state)
            WAIT_START: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = WAIT_START;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1; // done asserted one cycle after third byte
                next_state = WAIT_START;
            end
            default: next_state = WAIT_START;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

endmodule