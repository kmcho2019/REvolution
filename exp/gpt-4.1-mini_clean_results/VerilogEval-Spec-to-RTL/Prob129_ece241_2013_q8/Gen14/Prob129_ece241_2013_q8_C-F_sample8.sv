module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding: 2-bit localparam for minimal area and clarity
    localparam S_IDLE = 2'd0; // No bits matched
    localparam S_1    = 2'd1; // Matched '1'
    localparam S_10   = 2'd2; // Matched "10"

    reg [1:0] state, next_state;

    // Next state logic: case statement with default next_state = state
    always @(*) begin
        next_state = state; // default to avoid latches
        case (state)
            S_IDLE:  next_state = x ? S_1  : S_IDLE;
            S_1:     next_state = x ? S_1  : S_10;
            S_10:    next_state = x ? S_1  : S_IDLE;
            default: next_state = S_IDLE; // safe default
        endcase
    end

    // Output logic (Mealy): combinational, minimal logic depth
    always @(*) begin
        z = (state == S_10) && x;
    end

    // State register with asynchronous negative-edge reset on posedge clk
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule