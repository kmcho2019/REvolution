module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (in[3]) ? BYTE2 : IDLE;  // Wait for start byte
            BYTE2: next_state = BYTE3;                    // Second byte received
            BYTE3: next_state = IDLE;                     // Third byte received, back to IDLE
            default: next_state = IDLE;
        endcase
    end

    // done signal is combinational: high when transitioning from BYTE3 to IDLE
    assign done = (state == BYTE3);

endmodule