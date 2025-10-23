module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot encoded states: 5 states, each bit represents one state
    localparam S0    = 5'b00001; // no match
    localparam S1    = 5'b00010; // matched '1'
    localparam S11   = 5'b00100; // matched "11"
    localparam S110  = 5'b01000; // matched "110"
    localparam S1101 = 5'b10000; // detected "1101"

    reg [4:0] state, next_state;

    // Synchronous state register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next-state logic optimized for one-hot FSM
    always @(*) begin
        next_state = 5'b0; // default no state (safe)

        case (1'b1) // priority encoding with one-hot current state
            state[0]: // S0
                next_state = data ? S1 : S0;
            state[1]: // S1
                next_state = data ? S11 : S0;
            state[2]: // S11
                next_state = data ? S11 : S110;
            state[3]: // S110
                next_state = data ? S1101 : S0;
            state[4]: // S1101
                next_state = S1101; // latch detected state
            default:
                next_state = S0;
        endcase
    end

    // Output register: start_shifting asserted only when in detected state S1101
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else
            start_shifting <= (state == S1101);
    end

endmodule