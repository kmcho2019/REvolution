module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoded states
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state combinational logic
    always @* begin
        case (1'b1)
            state[A]: next_state = w ? A : B;
            state[B]: next_state = w ? D : C;
            state[C]: next_state = w ? D : E;
            state[D]: next_state = w ? A : F;
            state[E]: next_state = w ? D : E;
            state[F]: next_state = w ? D : C;
            default: next_state = A; // Safety fallback
        endcase
    end

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 in states E or F
    assign z = state[E] | state[F];

endmodule