module fsm(
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Sequence: 1 0 0 1 1
    // States represent how many bits of the sequence are matched
    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            3'd0: next_state = (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd1: next_state = (IN == 1'b0) ? 3'd2 : (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd2: next_state = (IN == 1'b0) ? 3'd3 : (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd3: next_state = (IN == 1'b1) ? 3'd4 : 3'd0;
            3'd4: next_state = (IN == 1'b1) ? 3'd5 : 3'd2;
            3'd5: next_state = (IN == 1'b1) ? 3'd1 : 3'd0;
            default: next_state = 3'd0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is 1 when next_state is full match (5) and input is 1
    // Because the sequence ends with input=1 that triggers transition to state=5
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule