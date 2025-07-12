module TopModule (
    input  clk,
    input  aresetn,  // active low async reset
    input  x,
    output reg z
);

    // State encoding with typedef enum for clarity
    typedef enum logic [1:0] {
        S0 = 2'b00, // no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t state, next_state;

    // Sequential logic with async negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = (x == 1'b0) ? S2 : S1;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic combinational (Mealy output)
    always @(*) begin
        // Assert z=1 only when in S2 and input x=1 (sequence "101" recognized)
        z = (state == S2) && x;
    end

endmodule