module TopModule(
    input  clk,
    input  aresetn,   // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding using localparam for clarity and synthesis friendliness
    localparam S0 = 2'd0;  // no bits matched yet
    localparam S1 = 2'd1;  // matched '1'
    localparam S2 = 2'd2;  // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic: combinational with case statement and default assignment to avoid latches
    always @(*) begin
        next_state = state; // default assignment
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0; // safe default
        endcase
    end

    // Mealy output logic: combinational, z asserted only when sequence "101" detected on input x=1 in S2
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