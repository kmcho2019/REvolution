module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // State encoding: minimal 3 states for recognizing "101"
    localparam [1:0]
        S0 = 2'b00,  // no bits matched yet
        S1 = 2'b01,  // matched '1'
        S2 = 2'b10;  // matched "10"

    reg [1:0] state, next_state;

    // Combinational next state logic with default to prevent latches
    always @(*) begin
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Asynchronous negative-edge reset, positive edge clock state register
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output asserted when sequence "101" detected: when in S2 and input x=1
    assign z = (state == S2) && x;

endmodule