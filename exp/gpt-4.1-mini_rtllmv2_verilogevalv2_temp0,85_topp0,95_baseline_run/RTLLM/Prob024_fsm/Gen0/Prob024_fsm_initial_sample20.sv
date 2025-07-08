module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    // States represent how many bits of the sequence 10011 have been matched so far
    localparam S0 = 3'd0; // initial state, no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
        case (state)
            S0: begin
                if (IN)
                    next_state = S1;  // got first '1'
                else
                    next_state = S0;
            end
            S1: begin
                if (!IN)
                    next_state = S2;  // got '10'
                else
                    next_state = S1;  // stay if another '1', pattern start again
            end
            S2: begin
                if (!IN)
                    next_state = S3;  // got '100'
                else
                    next_state = S1;  // '100' + '1' restart pattern at S1
            end
            S3: begin
                if (IN)
                    next_state = S4;  // got '1001'
                else
                    next_state = S0;  // mismatch, restart
            end
            S4: begin
                if (IN)
                    next_state = S1;  // got full '10011' and next bit is '1', restart with S1
                else
                    next_state = S2;  // got '10011' and next bit is '0', partial pattern continue from S2
            end
            default: next_state = S0;
        endcase
    end

    // Output and state update on posedge CLK or RST
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is 1 only when the current input IN completes the pattern "10011"
            // The last '1' of the pattern happens when state is S4 and input IN=1
            // Because Mealy outputs can depend on input + state, check next_state and input here:
            if (state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule