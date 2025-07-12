module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);
    // State encoding
    localparam S0 = 2'b00; // IDLE, no bits matched yet
    localparam S1 = 2'b01; // matched first '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // State register with async negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy): z = 1 when in S2 and input x=1 (i.e., sequence "101" detected)
    assign z = (state == S2) & x;

endmodule