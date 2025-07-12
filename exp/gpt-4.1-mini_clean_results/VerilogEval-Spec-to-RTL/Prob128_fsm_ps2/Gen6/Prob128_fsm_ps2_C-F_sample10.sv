module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);
    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    // Sequential logic for state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Done is asserted combinationally when current state is BYTE3,
    // i.e., the cycle after third byte was received
    assign done = (state == BYTE3);

endmodule