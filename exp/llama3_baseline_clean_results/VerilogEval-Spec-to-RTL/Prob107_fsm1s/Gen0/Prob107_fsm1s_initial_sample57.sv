module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // Define the states
    typedef enum logic [1:0] {
        B,
        A
    } state_t;

    state_t state, next_state;

    // Combinational logic to determine next state
    always_comb begin
        case (state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Combinational logic to determine output
    always_comb begin
        case (state)
            B: out = 1;
            A: out = 0;
            default: out = 1;
        endcase
    end

    // Sequential logic to update state
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

endmodule