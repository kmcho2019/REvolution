module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding using localparams for clarity and synthesis friendliness
    localparam S0 = 2'b00; // no bits matched yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // Next-state logic using case statement for better synthesis optimization and clarity
    always @(*) begin
        next_state = S0; // default to safe state to prevent latches
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0; // default case for safety
        endcase
    end

    // Mealy output logic: asserted when sequence "101" is detected (state S2 and x=1)
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