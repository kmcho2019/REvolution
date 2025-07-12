module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding using typedef enum for clarity and safety
    typedef enum logic [1:0] {
        S0 = 2'b00, // No matched bits yet
        S1 = 2'b01, // Matched '1'
        S2 = 2'b10  // Matched "10"
    } state_t;

    state_t current_state, next_state;

    // Asynchronous negative edge reset, synchronous state update at posedge clk
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next-state logic (combinational)
    always @(*) begin
        case (current_state)
            S0: next_state = (x == 1'b1) ? S1 : S0;
            S1: next_state = (x == 1'b0) ? S2 : S1;
            S2: next_state = (x == 1'b1) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy output): Assert z=1 only when sequence "101" detected
    always @(*) begin
        z = (current_state == S2 && x == 1'b1) ? 1'b1 : 1'b0;
    end

endmodule