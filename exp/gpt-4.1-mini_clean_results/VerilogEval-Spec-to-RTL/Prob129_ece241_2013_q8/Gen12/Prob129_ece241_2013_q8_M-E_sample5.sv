module TopModule (
    input  clk,
    input  aresetn,  // asynchronous active-low reset (negative edge)
    input  x,
    output reg z
);

    // Define states
    localparam S0 = 2'd0; // initial state, no bits matched
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic using case statement
    always @(*) begin
        case(state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic: z asserted when sequence "101" is detected at state S2 and x=1
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