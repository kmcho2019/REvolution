module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot encoded states: only one bit high per state
    localparam S0    = 5'b00001;  // no match
    localparam S1    = 5'b00010;  // matched '1'
    localparam S11   = 5'b00100;  // matched "11"
    localparam S110  = 5'b01000;  // matched "110"
    localparam S1101 = 5'b10000;  // matched "1101" (final detected state)

    reg [4:0] state, next_state;

    // Synchronous state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic (one-hot FSM)
    always @(*) begin
        case (1'b1)  // priority encoder on one-hot state bits
            state[0]:  next_state = data ? S1    : S0;
            state[1]:  next_state = data ? S11   : S0;
            state[2]:  next_state = data ? S11   : S110;
            state[3]:  next_state = data ? S1101 : S0;
            state[4]:  next_state = S1101; // latch detected state forever
            default:   next_state = S0;    // should not occur
        endcase
    end

    // Moore output register: asserted only in final detected state
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else
            start_shifting <= (state == S1101);
    end

endmodule