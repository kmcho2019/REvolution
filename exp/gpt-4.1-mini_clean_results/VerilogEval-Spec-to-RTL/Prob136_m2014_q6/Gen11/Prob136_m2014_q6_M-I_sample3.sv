module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Combinational next state logic using one-hot encoding
    always @(*) begin
        case (1'b1) // synthesis parallel_case full_case
            state[A]: next_state = w ? A : B;
            state[B]: next_state = w ? D : C;
            state[C]: next_state = w ? D : E;
            state[D]: next_state = w ? A : F;
            state[E]: next_state = w ? D : E;
            state[F]: next_state = w ? D : C;
            default:  next_state = A; // default to reset state
        endcase
    end

    // Sequential state register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Registered output logic: z=1 only in states E or F
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= (state == E) || (state == F);
    end

endmodule