module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // States represent how many bits matched of "10011"
    // 0: no match
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // 5: matched '10011' (output MATCH here)

    reg [2:0] state, next_state;

    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            3'd0: next_state = (IN) ? 3'd1 : 3'd0;          // expecting '1' to start
            3'd1: next_state = (IN) ? 3'd1 : 3'd2;          // got '1', next expect '0'
            3'd2: next_state = (IN) ? 3'd1 : 3'd3;          // got '10', next expect '0'
            3'd3: next_state = (IN) ? 3'd4 : 3'd0;          // got '100', next expect '1'
            3'd4: next_state = (IN) ? 3'd5 : 3'd2;          // got '1001', next expect '1' or overlap '10'
            3'd5: next_state = (IN) ? 3'd1 : 3'd2;          // matched full seq, on IN advance for overlap
            default: next_state = 3'd0;
        endcase
    end

    // MATCH is high when current input IN completes the sequence in state 4 with IN=1 (Mealy)
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule