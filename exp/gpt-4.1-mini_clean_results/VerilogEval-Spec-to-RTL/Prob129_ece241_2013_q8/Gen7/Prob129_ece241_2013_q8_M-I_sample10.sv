module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding (2 bits)
    localparam S_IDLE = 2'd0; // no bits matched
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // State register with asynchronous negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            S_IDLE:  next_state = (x) ? S_1  : S_IDLE;
            S_1:     next_state = (x) ? S_1  : S_10;
            S_10:    next_state = (x) ? S_1  : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic separated (Mealy output)
    always @(*) begin
        // z is asserted only when state is S_10 and input x is 1 (detect '101')
        z = (state == S_10) && x;
    end

endmodule