module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding with localparam for compatibility and minimal overhead
    localparam [1:0]
        S_IDLE = 2'd0, // no bits matched yet
        S_1    = 2'd1, // matched '1'
        S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        // Default assignment to avoid latches
        next_state = S_IDLE;
        case (state)
            S_IDLE: next_state = x ? S_1 : S_IDLE;
            S_1:     next_state = x ? S_1 : S_10;
            S_10:    next_state = x ? S_1 : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic (Mealy): z asserted when sequence "101" ends (state S_10, input x=1)
    always @(*) begin
        z = (state == S_10) && (x == 1'b1);
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule