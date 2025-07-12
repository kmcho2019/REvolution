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
    wire state_update_en;

    // Clock gating for stable states
    assign state_update_en = reset || 
                           !((state == E && !w) || 
                             (state == A && w));

    // Next state logic - parallel case for better synthesis
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: state = w ? A : B;
            state[B]: state = w ? D : C;
            state[C]: state = w ? D : E;
            state[D]: state = w ? A : F;
            state[E]: state = w ? D : E;
            state[F]: state = w ? D : C;
            default:  state = A;
        endcase
    end

    // State register with clock gating
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (state_update_en)
            state <= next_state;
    end

    // Output is directly mapped from state bits
    assign z = state[E] | state[F];

endmodule