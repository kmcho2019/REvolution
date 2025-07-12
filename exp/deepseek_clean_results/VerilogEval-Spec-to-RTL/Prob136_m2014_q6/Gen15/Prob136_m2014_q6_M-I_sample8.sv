module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoded states (better for small FSMs)
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state;
    wire clk_enable = (state != A) || (w != 1'b1); // Clock gating when staying in A

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end
        else if (clk_enable) begin
            case (1'b1) // synthesis parallel_case
                state[A]: state <= w ? A : B;
                state[B]: state <= w ? D : C;
                state[C]: state <= w ? D : E;
                state[D]: state <= w ? A : F;
                state[E]: state <= w ? D : E;
                state[F]: state <= w ? D : C;
                default: state <= A;
            endcase

            // Registered output for better timing
            z <= (state == E) | (state == F);
        end
    end

endmodule