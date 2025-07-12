module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoding with output optimization
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state, next_state;
    reg w_prev;
    wire clk_en;

    // Clock gating control
    assign clk_en = (w != w_prev) | reset;

    // State transition logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: next_state = w ? A : B;
            state[B]: next_state = w ? D : C;
            state[C]: next_state = w ? D : E;
            state[D]: next_state = w ? A : F;
            state[E]: next_state = w ? D : E;
            state[F]: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // State register with clock gating
    always @(posedge clk) begin
        w_prev <= w;
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end
        else if (clk_en) begin
            state <= next_state;
            // Output register for pipelining
            z <= state[E] | state[F];
        end
    end

endmodule