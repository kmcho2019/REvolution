module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding for clarity and synthesis efficiency
    localparam S0 = 2'd0; // no bits matched yet
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic using a case statement with explicit default
    always @(*) begin
        next_state = S0; // default assignment to prevent latches
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic: assert z when "101" detected (in S2 and x=1)
    always @(*) begin
        z = 1'b0; // default output
        if ((state == S2) && x)
            z = 1'b1;
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule