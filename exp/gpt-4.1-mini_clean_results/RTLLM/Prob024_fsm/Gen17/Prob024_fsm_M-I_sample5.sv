module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary) for partial matching of "10011"
    // 0: Idle, no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // States 5-7 unused

    reg [2:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Next state logic: binary-encoded FSM transitions
    always @(*) begin
        case (state)
            3'd0: begin // Idle
                if (IN == 1'b1)
                    next_state = 3'd1; // matched '1'
                else
                    next_state = 3'd0; // remain idle
            end
            3'd1: begin // matched '1'
                if (IN == 1'b0)
                    next_state = 3'd2; // matched '10'
                else
                    next_state = 3'd1; // remain in matched '1' (for overlapping)
            end
            3'd2: begin // matched '10'
                if (IN == 1'b0)
                    next_state = 3'd3; // matched '100'
                else
                    next_state = 3'd1; // restart matched '1'
            end
            3'd3: begin // matched '100'
                if (IN == 1'b1)
                    next_state = 3'd4; // matched '1001'
                else
                    next_state = 3'd0; // reset to idle
            end
            3'd4: begin // matched '1001'
                // Full sequence "10011" completes on IN=1 here (Mealy output)
                if (IN == 1'b1)
                    next_state = 3'd1; // overlapping, restart matched '1'
                else
                    next_state = 3'd2; // matched '10' (sequence suffix)
            end
            default: next_state = 3'd0; // default to idle
        endcase
    end

    // Mealy output MATCH = 1 when in state '1001' and input IN=1 (sequence complete)
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule