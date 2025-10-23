module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // Gray-coded states to reduce bit toggling between states
    localparam S0 = 2'b00; // no bits matched yet
    localparam S1 = 2'b01; // matched '1'       (from S0, toggle bit0)
    localparam S2 = 2'b11; // matched "10"      (from S1, toggle bit1)

    reg [1:0] state, next_state;

    // Next-state logic using case for clarity and potential synthesis improvement
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic: z asserted when detecting sequence "101" at input x=1 in state S2
    always @(*) begin
        z = (state == S2) && x;
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule