module TopModule (
    input  clk,
    input  aresetn,  // asynchronous reset, active low, negative edge triggered
    input  x,
    output reg z
);

    // One-hot state encoding for 3 states
    // Only one bit set at a time:
    // S0 = 3'b001 : no match
    // S1 = 3'b010 : matched '1'
    // S2 = 3'b100 : matched "10"
    localparam [2:0]
        S0 = 3'b001,
        S1 = 3'b010,
        S2 = 3'b100;

    reg [2:0] state, next_state;

    // Next-state logic combinational
    always @(*) begin
        next_state = 3'b000; // default to invalid to catch coding errors
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0; // default/reset safety
        endcase
    end

    // Mealy output logic combinational: z=1 when sequence "101" detected
    // This happens when current state is S2 and input x=1 (transition to S1)
    always @(*) begin
        z = (state == S2) && x;
    end

    // State register with asynchronous active-low reset on negative edge of aresetn
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule