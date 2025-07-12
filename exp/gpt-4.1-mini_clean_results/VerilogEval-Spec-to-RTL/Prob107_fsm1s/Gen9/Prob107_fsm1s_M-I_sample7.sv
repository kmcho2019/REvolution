module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

    // Enumerated state type for clarity and synthesis friendliness
    typedef enum logic {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-high reset
    always_ff @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Combined next state and output logic
    always_comb begin
        case(state)
            B: begin
                out = 1'b1;
                next_state = (in == 1'b0) ? A : B;
            end
            A: begin
                out = 1'b0;
                next_state = (in == 1'b0) ? B : A;
            end
            default: begin
                out = 1'b1;
                next_state = B;
            end
        endcase
    end

endmodule