module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // State encoding
    localparam S_IDLE = 2'd0; // no bits matched yet
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic (combinational) using case for compactness
    always @(*) begin
        case (state)
            S_IDLE:   next_state = x ? S_1  : S_IDLE;
            S_1:      next_state = x ? S_1  : S_10;
            S_10:     next_state = x ? S_1  : S_IDLE;
            default:  next_state = S_IDLE;
        endcase
    end

    // State register with async negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Output logic as continuous assignment (Mealy output)
    // z = 1 when current state is S_10 and input x is 1
    assign z = (state == S_10) && x;

endmodule