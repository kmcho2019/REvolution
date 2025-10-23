module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding for 3 states, minimal 2-bit
    localparam S0 = 2'b00; // no bits matched
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic: combinational with default assignment and case statement
    always @(*) begin
        next_state = state;  // default
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic: combinational, asserted when in S2 and x=1
    always @(*) begin
        z = 1'b0;
        if (state == S2 && x)
            z = 1'b1;
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule