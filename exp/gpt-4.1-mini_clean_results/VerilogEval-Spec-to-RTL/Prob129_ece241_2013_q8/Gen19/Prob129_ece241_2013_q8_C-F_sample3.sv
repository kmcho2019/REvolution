module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // State encoding: 3 states encoded in 2 bits
    localparam [1:0]
        S0 = 2'b00,  // no bits matched yet
        S1 = 2'b01,  // matched '1'
        S2 = 2'b10;  // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic: combinational with default next_state assignment to avoid latches
    always @(*) begin
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Asynchronous negative edge reset, synchronous state update on posedge clk
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic: combinational, asserted when current state is S2 and input x=1
    assign z = (state == S2) && x;

endmodule