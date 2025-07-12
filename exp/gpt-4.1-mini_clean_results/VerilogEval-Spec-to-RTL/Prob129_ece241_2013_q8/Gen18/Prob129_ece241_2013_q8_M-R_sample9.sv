module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // State encoding: 3 states for sequence "101" detection
    localparam [1:0]
        S0 = 2'b00,  // no bits matched yet
        S1 = 2'b01,  // matched '1'
        S2 = 2'b10;  // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic with a case statement for clarity
    always @(*) begin
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic: asserted when in S2 and x == 1
    assign z = (state == S2) && x;

endmodule