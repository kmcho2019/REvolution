module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding: matched prefix length of the sequence "10011"
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next-state logic: combinational, simplified transitions
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

    // Sequential logic: synchronous reset, state update, and registered MATCH output
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH registered: set on transition that completes "10011"
            // i.e., when current state is S4 and input IN=1 completes the sequence
            MATCH <= (state == S4) && (IN == 1'b1);
        end
    end

endmodule