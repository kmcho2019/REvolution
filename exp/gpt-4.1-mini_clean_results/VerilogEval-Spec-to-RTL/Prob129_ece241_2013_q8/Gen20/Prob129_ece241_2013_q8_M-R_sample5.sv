module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // State encoding using localparam for synthesis friendliness and minimal area
    localparam S_IDLE = 2'd0; // no bits matched yet, waiting for '1'
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic using case statement for clarity and synthesis friendliness
    always @(*) begin
        case(state)
            S_IDLE:    next_state = x ? S_1  : S_IDLE;
            S_1:       next_state = x ? S_1  : S_10;
            S_10:      next_state = x ? S_1  : S_IDLE;
            default:   next_state = S_IDLE;
        endcase
    end

    // Output logic (Mealy): output asserted combinationally when detecting "101"
    assign z = (state == S_10) && x;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule