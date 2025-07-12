module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // State encoding: 2-bit localparam for minimal area and clarity
    localparam S_IDLE = 2'd0; // No bits matched
    localparam S_1    = 2'd1; // Matched '1'
    localparam S_10   = 2'd2; // Matched "10"

    reg [1:0] state, next_state;

    // Next state logic: combinational always block with default assignment
    always @(*) begin
        next_state = state; // default to avoid latches
        case (state)
            S_IDLE:  next_state = x ? S_1  : S_IDLE;
            S_1:     next_state = x ? S_1  : S_10;
            S_10:    next_state = x ? S_1  : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // State register with asynchronous negative-edge reset on posedge clk
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Output logic (Mealy): continuous assignment for minimal latency and area
    assign z = (state == S_10) && x;

endmodule