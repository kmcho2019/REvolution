module TopModule (
    input  clk,
    input  aresetn,  // asynchronous active low reset
    input  x,
    output reg z
);

    // One-hot encoding of states (3 bits for 3 states)
    localparam [2:0]
        S0 = 3'b001,  // initial state, no match
        S1 = 3'b010,  // matched '1'
        S2 = 3'b100;  // matched "10"

    reg [2:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        // Default next state to current state (to avoid latches)
        next_state = S0;
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic (asserted only on detecting "101" pattern)
    always @(*) begin
        // Default output low
        z = 1'b0;
        // Output asserted when in S2 and input is 1 (i.e., "101" detected)
        if ((state == S2) && x)
            z = 1'b1;
    end

    // State register with asynchronous active low reset on negative edge
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule