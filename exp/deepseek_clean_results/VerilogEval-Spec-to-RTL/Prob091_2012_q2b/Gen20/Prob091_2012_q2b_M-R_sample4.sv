module TopModule (
    input [5:0] y,    // One-hot encoded state: y[5:0] = FEDCBA
    input w,          // State machine input
    output reg Y1,    // Next state for y[1] (B state flip-flop input)
    output reg Y3     // Next state for y[3] (D state flip-flop input)
);

    // State encoding (one-hot):
    // y[0] = 000001 = A
    // y[1] = 000010 = B
    // y[2] = 000100 = C
    // y[3] = 001000 = D
    // y[4] = 010000 = E
    // y[5] = 100000 = F

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        casez (y)
            6'b000001: begin // State A
                Y1 = w;       // A->B if w=1
                Y3 = 1'b0;
            end
            6'b000010: begin // State B
                Y3 = ~w;      // B->D if w=0
            end
            6'b000100: begin // State C
                Y3 = ~w;      // C->D if w=0
            end
            6'b001000: begin // State D
                Y3 = 1'b0;    // No self-transition to D
            end
            6'b010000: begin // State E
                Y3 = ~w;      // E->D if w=0
            end
            6'b100000: begin // State F
                Y3 = ~w;      // F->D if w=0
            end
            default: begin   // Handle undefined states
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule