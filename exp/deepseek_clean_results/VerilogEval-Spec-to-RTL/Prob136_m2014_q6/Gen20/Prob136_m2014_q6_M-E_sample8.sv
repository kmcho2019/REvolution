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
    wire z_comb;

    // Combinational next-state logic
    always @(*) begin
        next_state = 6'b0;
        case (1'b1) // synthesis parallel_case
            state[A]: next_state = w ? A : B;
            state[B]: next_state = w ? D : C;
            state[C]: next_state = w ? D : E;
            state[D]: next_state = w ? A : F;
            state[E]: next_state = w ? D : E;
            state[F]: next_state = w ? D : C;
        endcase
    end

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational output (pre-pipeline)
    assign z_comb = state[E] | state[F];

    // Output pipeline register
    always @(posedge clk) begin
        z <= z_comb;
    end

endmodule