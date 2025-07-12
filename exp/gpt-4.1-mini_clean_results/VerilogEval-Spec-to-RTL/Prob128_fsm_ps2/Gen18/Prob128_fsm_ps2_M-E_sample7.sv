module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2,
        BYTE3 = 2'd3
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // done is asserted only in BYTE3 state (i.e., after third byte received)
            done <= (state == BYTE3);
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start byte with in[3] = 1
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;  // after first byte, go to second byte
            BYTE2: next_state = BYTE3;  // after second byte, go to third byte
            BYTE3: next_state = IDLE;   // after third byte and done signal, go back to IDLE to find new message start
            default: next_state = IDLE;
        endcase
    end

endmodule