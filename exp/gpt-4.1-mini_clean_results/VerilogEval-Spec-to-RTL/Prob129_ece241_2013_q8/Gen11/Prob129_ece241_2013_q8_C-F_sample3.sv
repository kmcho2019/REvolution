module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // State encoding (2 bits for 3 states)
    localparam S_IDLE = 2'd0; // no match yet
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state combinational logic using case for clarity and optimal synthesis
    always @(*) begin
        case (state)
            S_IDLE:  next_state = x ? S_1  : S_IDLE;
            S_1:     next_state = x ? S_1  : S_10;
            S_10:    next_state = x ? S_1  : S_IDLE;
            default: next_state = S_IDLE; // safe default for synthesis
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Mealy output as continuous assignment for simplicity and better synthesis
    // Output asserted when in S_10 and input x == 1, meaning sequence "101" detected
    assign z = (state == S_10) && x;

endmodule