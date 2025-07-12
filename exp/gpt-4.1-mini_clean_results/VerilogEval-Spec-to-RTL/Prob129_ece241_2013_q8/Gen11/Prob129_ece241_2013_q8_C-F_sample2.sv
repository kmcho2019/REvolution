module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparam for clarity and synthesis friendliness
    localparam S_IDLE = 2'd0; // no bits matched yet, waiting for '1'
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic: combinational with default assignment to prevent latches
    always @(*) begin
        next_state = state; // default assignment

        case (state)
            S_IDLE:  next_state = x ? S_1  : S_IDLE;
            S_1:     next_state = x ? S_1  : S_10;
            S_10:    next_state = x ? S_1  : S_IDLE;
            default: next_state = S_IDLE; // safe default
        endcase
    end

    // Output logic (Mealy): combinational and purely dependent on current state and input
    always @(*) begin
        z = 1'b0; // default de-asserted
        if ((state == S_10) && (x == 1'b1))
            z = 1'b1; // assert output when '101' detected
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule