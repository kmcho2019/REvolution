module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // FSM states encoding
    localparam STATE_WAIT  = 2'd0;
    localparam STATE_BYTE2 = 2'd1;
    localparam STATE_BYTE3 = 2'd2;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        done = 1'b0; // default no done pulse

        case (state)
            STATE_WAIT: begin
                // Wait for a start byte with in[3] == 1
                if (in[3])
                    next_state = STATE_BYTE2;
                else
                    next_state = STATE_WAIT;
            end

            STATE_BYTE2: begin
                // After receiving second byte, go to third byte state
                next_state = STATE_BYTE3;
            end

            STATE_BYTE3: begin
                // After third byte received, signal done and return to wait
                next_state = STATE_WAIT;
                done = 1'b1;
            end

            default: begin
                next_state = STATE_WAIT;
            end
        endcase
    end

    // State register update and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_WAIT;
            done  <= 1'b0;
        end else begin
            state <= next_state;

            // done is assigned combinationally above, but must register it here
            // to produce a single cycle pulse synchronized with state transition,
            // so delay done from combinational logic by one cycle:
            // solution: generate done as output reg in state machine register stage.
            // Therefore, implement done with a separate register updated here:

            // done updated according to next_state transition:
            // But done combinational assigned above, so reassign here:

            // We'll move done assignment here for clarity:
            done <= (state == STATE_BYTE3);
        end
    end

endmodule