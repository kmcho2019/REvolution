module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state;
    wire clk_en;

    // Clock gating for stable states
    assign clk_en = ~((state == E && ~w) || (state == A && w)) || reset;

    // Next state logic (direct combinational)
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: state_nxt = w ? A : B;
            state[B]: state_nxt = w ? D : C;
            state[C]: state_nxt = w ? D : E;
            state[D]: state_nxt = w ? A : F;
            state[E]: state_nxt = w ? D : E;
            state[F]: state_nxt = w ? D : C;
            default:  state_nxt = A;
        endcase
    end

    // State transition with gated clock
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (clk_en)
            state <= state_nxt;
    end

    // Output is OR of E and F bits
    assign z = state[E] | state[F];

endmodule