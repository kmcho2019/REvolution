module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding for three states of the FSM
    localparam S_IDLE = 2'd0; // no bits matched yet
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic using a case statement for clarity and synthesis friendliness
    always @(*) begin
        case (state)
            S_IDLE:  next_state = x ? S_1   : S_IDLE;
            S_1:     next_state = x ? S_1   : S_10;
            S_10:    next_state = x ? S_1   : S_IDLE;
            default: next_state = S_IDLE; // safe fallback
        endcase
    end

    // Mealy output logic: assert 'z' when sequence "101" is detected on input 'x'
    always @(*) begin
        z = (state == S_10) && x;
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule