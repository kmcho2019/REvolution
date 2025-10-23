module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE2          = 2'b01,
        BYTE3          = 2'b10
    } state_t;

    state_t state, next_state;
    reg done_int;

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START:
                next_state = in[3] ? BYTE2 : WAIT_FOR_START;
            BYTE2:
                next_state = BYTE3;
            BYTE3:
                next_state = WAIT_FOR_START;
            default:
                next_state = WAIT_FOR_START;
        endcase
    end

    // Combinational done logic: done asserted one cycle after the third byte
    always @(*) begin
        done_int = (state == BYTE3);
    end

    // State and done registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_int;
        end
    end

endmodule