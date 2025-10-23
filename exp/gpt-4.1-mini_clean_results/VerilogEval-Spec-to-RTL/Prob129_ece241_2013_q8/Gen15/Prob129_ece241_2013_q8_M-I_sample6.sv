module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding for minimal logic depth
    localparam S_IDLE = 3'b001;  // no bits matched yet, waiting for '1'
    localparam S_1    = 3'b010;  // matched '1'
    localparam S_10   = 3'b100;  // matched "10"

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            S_IDLE:  next_state = x ? S_1 : S_IDLE;
            S_1:     next_state = x ? S_1 : S_10;
            S_10:    next_state = x ? S_1 : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic (Mealy): output 'z' is asserted when input x = 1 in S_10 state
    always @(*) begin
        z = (state == S_10) && (x == 1'b1);
    end

    // State register with asynchronous negative-edge reset (as required)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule