module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // State encoding using localparam for synthesis friendliness and minimal area
    localparam [1:0]
        S_IDLE = 2'd0,  // no bits matched yet, waiting for '1'
        S_1    = 2'd1,  // matched '1'
        S_10   = 2'd2;  // matched "10"

    reg [1:0] state, next_state;

    // Next state logic (combinational), default next_state to current state to avoid inferred latches
    always @(*) begin
        case(state)
            S_IDLE:  next_state = x ? S_1 : S_IDLE;
            S_1:     next_state = x ? S_1 : S_10;
            S_10:    next_state = x ? S_1 : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Mealy output: asserted when sequence "101" detected, combinational logic via continuous assign
    assign z = (state == S_10) && x;

endmodule