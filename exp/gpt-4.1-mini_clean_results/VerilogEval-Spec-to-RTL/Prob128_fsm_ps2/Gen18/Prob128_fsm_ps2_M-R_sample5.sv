module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // Define FSM states
    typedef enum logic [1:0] {
        IDLE  = 2'b00, // waiting for start byte in[3]=1
        BYTE2 = 2'b01, // received first byte, expecting second
        BYTE3 = 2'b10  // received second byte, expecting third
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end

            BYTE2: begin
                next_state = BYTE3;
            end

            BYTE3: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // done is asserted one cycle after the third byte (i.e., on BYTE3 state)
    assign done = (state == BYTE3);

endmodule