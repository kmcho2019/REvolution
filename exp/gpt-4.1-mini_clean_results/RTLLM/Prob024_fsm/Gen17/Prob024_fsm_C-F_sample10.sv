module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot encoding of states representing prefixes of "10011"
    localparam [4:0]
        S0 = 5'b00001, // no match
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched '10'
        S3 = 5'b01000, // matched '100'
        S4 = 5'b10000; // matched '1001'

    reg [4:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;  // detected first '1'
                else
                    next_state = S0;  // remain in initial state
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;  // '10' matched
                else
                    next_state = S1;  // remain matched '1' (new start)
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;  // '100' matched
                else
                    next_state = S1;  // overlap restart with '1'
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;  // '1001' matched
                else
                    next_state = S0;  // mismatch resets FSM
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S1;  // full sequence matched; start new pattern
                else
                    next_state = S2;  // partial overlap with '0' at second bit
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic: update state on clock with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when in S4 and IN=1 indicating full "10011" detected
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule