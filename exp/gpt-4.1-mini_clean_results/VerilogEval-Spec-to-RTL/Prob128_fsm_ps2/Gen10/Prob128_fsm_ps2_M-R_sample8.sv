module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t current_state, next_state;

    // done is high only in BYTE3 state (indicates third byte received)
    assign done = (current_state == BYTE3);

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2; // after BYTE1 received, move to BYTE2
                else
                    next_state = IDLE;
            end
            BYTE2: next_state = BYTE3;  // after second byte
            BYTE3: next_state = IDLE;   // done after third byte, return to IDLE
            default: next_state = IDLE;
        endcase
    end

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

endmodule