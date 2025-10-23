module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary state encoding for 5 states representing progress in detecting "10011"
    localparam [2:0]
        S0 = 3'd0,  // initial state, no bits matched
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Combinational logic to determine next state based on current state and input IN
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Sequential logic to update state at rising clock edge or reset synchronously
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is high when in state S4 and input IN=1 (last bit of sequence detected)
    assign MATCH = (state == S4) && IN;

endmodule