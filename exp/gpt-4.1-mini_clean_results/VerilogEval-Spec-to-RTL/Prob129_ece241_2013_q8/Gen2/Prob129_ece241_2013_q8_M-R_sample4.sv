module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // initial state, no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched "10"
    } state_t;

    state_t state, next_state;

    // State register with async negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (x == 1'b1) ? S1 : S0;
            S1: next_state = (x == 1'b0) ? S2 : S1;
            S2: next_state = (x == 1'b1) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy output depends on current state and input)
    always @(*) begin
        if (state == S2 && x == 1'b1)
            z = 1'b1;  // sequence "101" detected
        else
            z = 1'b0;
    end

endmodule