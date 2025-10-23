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

    reg [5:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[A]: begin
                    state <= w ? A : B;
                    z <= 1'b0;
                end
                state[B]: begin
                    state <= w ? D : C;
                    z <= 1'b0;
                end
                state[C]: begin
                    state <= w ? D : E;
                    z <= 1'b0;
                end
                state[D]: begin
                    state <= w ? A : F;
                    z <= 1'b0;
                end
                state[E]: begin
                    state <= w ? D : E;
                    z <= 1'b1;
                end
                state[F]: begin
                    state <= w ? D : C;
                    z <= 1'b1;
                end
                default: begin
                    state <= A;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule