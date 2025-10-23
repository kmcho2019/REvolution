module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // One-hot state encoding for three states:
    // S0 = 3'b001, S1 = 3'b010, S2 = 3'b100
    localparam S0 = 3'b001; // no bits matched yet
    localparam S1 = 3'b010; // matched '1'
    localparam S2 = 3'b100; // matched "10"

    reg [2:0] state, next_state;

    // Next-state logic: use case statement for clarity and potential synthesis optimization
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic: assert z when in state S2 and x == 1
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