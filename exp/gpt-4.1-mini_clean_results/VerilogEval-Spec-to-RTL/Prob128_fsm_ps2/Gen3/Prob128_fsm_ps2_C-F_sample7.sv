module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);

    // State encoding using typedef enum for clarity and safety
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'd0,
        BYTE2          = 2'd1,
        BYTE3          = 2'd2
    } state_t;

    state_t state, next_state;

    // State and done register update on rising clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // done asserted only for one cycle immediately after third byte received
            done  <= (state == BYTE3);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: next_state = (in[3] == 1'b1) ? BYTE2 : WAIT_FOR_START;
            BYTE2:          next_state = BYTE3;
            BYTE3:          next_state = WAIT_FOR_START;
            default:        next_state = WAIT_FOR_START;
        endcase
    end

endmodule