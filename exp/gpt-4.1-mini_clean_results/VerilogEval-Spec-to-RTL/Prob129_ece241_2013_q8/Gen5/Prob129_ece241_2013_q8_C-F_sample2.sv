module TopModule (
    input  clk,
    input  aresetn,  // active low async reset
    input  x,
    output reg z
);

    // State encoding using typedef enum for clarity
    typedef enum logic [1:0] {
        S0 = 2'b00, // initial state, no match
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t current_state, next_state;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = (x == 1'b1) ? S1 : S0;
            S1: next_state = (x == 1'b0) ? S2 : S1;
            S2: next_state = (x == 1'b1) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy output)
    always @(*) begin
        z = (current_state == S2 && x == 1'b1) ? 1'b1 : 1'b0;
    end

endmodule