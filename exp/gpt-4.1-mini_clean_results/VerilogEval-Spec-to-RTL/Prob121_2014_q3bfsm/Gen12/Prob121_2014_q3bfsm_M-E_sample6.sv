module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire x,
    output reg  z
);

    // Define the states as an enumerated type for clarity
    typedef enum logic [2:0] {
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4
    } state_t;

    state_t state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state combinational logic
    always @(*) begin
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // Output logic purely combinational based on current state
    always @(*) begin
        case(state)
            S3, S4: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule