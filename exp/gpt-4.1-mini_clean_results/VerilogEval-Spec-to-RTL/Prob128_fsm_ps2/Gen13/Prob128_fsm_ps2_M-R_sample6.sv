module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
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
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3])
                    next_state = BYTE2;  // Start of a new message
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // done is asserted for one cycle after the third byte is received (state BYTE3 to IDLE)
    assign done = (state == BYTE3) && (next_state != BYTE3);

endmodule