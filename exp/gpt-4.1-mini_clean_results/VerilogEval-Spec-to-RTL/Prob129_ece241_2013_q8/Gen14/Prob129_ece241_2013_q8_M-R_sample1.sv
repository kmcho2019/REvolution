module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparam for clarity and synthesis friendliness
    localparam [1:0] 
        S_IDLE = 2'd0,  // No bits matched
        S_1    = 2'd1,  // Matched '1'
        S_10   = 2'd2;  // Matched "10"

    reg [1:0] state, next_state;

    // Next state logic using case for better clarity
    always @(*) begin
        case (state)
            S_IDLE: next_state = (x) ? S_1 : S_IDLE;
            S_1:    next_state = (x) ? S_1 : S_10;
            S_10:   next_state = (x) ? S_1 : S_IDLE;
            default: next_state = S_IDLE; // Safe default
        endcase
    end

    // Output logic (Mealy): Assert z when in S_10 state and input x is 1
    always @(*) begin
        z = (state == S_10) && x;
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule