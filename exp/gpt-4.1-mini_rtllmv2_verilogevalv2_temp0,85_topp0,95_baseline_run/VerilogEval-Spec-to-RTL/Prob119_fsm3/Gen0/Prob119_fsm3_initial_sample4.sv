module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3
    } state_t;

    state_t state, next_state;

    // Next state logic
    always_comb begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with asynchronous active-high reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: Moore output depends only on state
    always_comb begin
        case (state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule