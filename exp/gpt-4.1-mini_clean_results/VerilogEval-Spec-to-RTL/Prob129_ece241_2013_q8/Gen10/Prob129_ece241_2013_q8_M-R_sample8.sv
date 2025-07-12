module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output      z
);

    // State encoding using localparam
    localparam [1:0]
        S_IDLE = 2'd0,
        S_1    = 2'd1,
        S_10   = 2'd2;

    reg [1:0] state, next_state;

    // Next state logic using case statement
    always @(*) begin
        case(state)
            S_IDLE:  next_state = x ? S_1  : S_IDLE;
            S_1:     next_state = x ? S_1  : S_10;
            S_10:    next_state = x ? S_1  : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic (Mealy), combinational assign statement
    assign z = (state == S_10) && x;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule