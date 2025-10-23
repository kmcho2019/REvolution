module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = 6'b0;
        unique case (1'b1)  // Synthesis parallel case
            state[A]: next_state = w ? A : B;
            state[B]: next_state = w ? D : C;
            state[C]: next_state = w ? D : E;
            state[D]: next_state = w ? A : F;
            state[E]: next_state = w ? D : E;
            state[F]: next_state = w ? D : C;
            default:   next_state = A;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output pipelining
            z <= state[E] | state[F];  // Output based on current state
        end
    end

endmodule