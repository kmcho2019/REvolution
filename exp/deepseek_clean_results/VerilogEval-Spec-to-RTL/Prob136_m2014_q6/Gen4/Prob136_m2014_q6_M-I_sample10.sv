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

    reg [5:0] current_state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Combinational logic for next state
    always @(*) begin
        next_state = 6'b0; // Default to avoid latch
        case (1'b1) // Synthesis will recognize this as one-hot
            current_state[A]: next_state = w ? A : B;
            current_state[B]: next_state = w ? D : C;
            current_state[C]: next_state = w ? D : E;
            current_state[D]: next_state = w ? A : F;
            current_state[E]: next_state = w ? D : E;
            current_state[F]: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // Registered output logic (improves timing)
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= current_state[E] | current_state[F];
    end

endmodule