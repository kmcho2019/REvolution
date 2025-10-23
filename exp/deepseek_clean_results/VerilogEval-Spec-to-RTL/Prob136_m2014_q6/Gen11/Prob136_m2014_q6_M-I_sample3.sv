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

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[A]: state <= w ? A : B;
                state[B]: state <= w ? D : C;
                state[C]: state <= w ? D : E;
                state[D]: state <= w ? A : F;
                state[E]: state <= w ? D : E;
                state[F]: state <= w ? D : C;
                default: state <= A;
            endcase
        end
    end

    // Output logic - z=1 for states E and F (bits 4 and 5)
    assign z = state[5] | state[4];

endmodule