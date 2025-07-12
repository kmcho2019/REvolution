module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    localparam [1:0]
        S_IDLE = 2'b00, // waiting for '1'
        S_1    = 2'b01, // matched '1'
        S_10   = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // Next state logic: case statement for clarity and synthesis optimization
    always @(*) begin
        case (state)
            S_IDLE: next_state = x ? S_1 : S_IDLE;
            S_1:    next_state = x ? S_1 : S_10;
            S_10:   next_state = x ? S_1 : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic (Mealy): assert z when detecting '1' at input in S_10 state
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