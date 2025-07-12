module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);
    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        case (1'b1 << y)
            // Not a valid approach; y is already one-hot encoded.
            // Instead, we check which bit in y is set.

            // Since y is one-hot, we can check which bit is set.
            // We'll implement as if-else ladder for clarity:
            default: begin
                if (y[0]) begin // State A
                    Y1 = w;     // A(0) --1--> B
                    Y3 = 1'b0;  // no transition to D from A
                end
                else if (y[1]) begin // State B
                    Y1 = 1'b0;  // B(0) --1--> C (y[2]), no B input
                    Y3 = ~w;    // B(0) --0--> D (y[3]) if w=0
                end
                else if (y[2]) begin // State C
                    Y1 = 1'b0;   // no B input
                    Y3 = ~w;     // C(0) --0--> D (y[3]) if w=0
                end
                else if (y[3]) begin // State D
                    Y1 = 1'b0;   // no B input
                    Y3 = ~w;     // D(0) --0--> A(0) but A is y[0], so no Y3
                    // Actually Y3 is input to D, so here it's transition to D (next) - not relevant when current is D
                    // From D(0): 1 -> F(y[5]), 0 -> A(y[0]), so no input to B or D
                    Y3 = 1'b0;
                end
                else if (y[4]) begin // State E
                    Y1 = 1'b0;
                    Y3 = 1'b0;  // E(1) transitions to E or D but only D input is Y3, and E->D is on w=0
                    if (~w)
                        Y3 = 1'b1; // w=0 goes to D (Y3)
                end
                else if (y[5]) begin // State F
                    Y1 = 1'b0;
                    Y3 = ~w;  // F(1) --0--> D(3)
                end
                else begin
                    // No valid current state; keep outputs zero
                    Y1 = 1'b0;
                    Y3 = 1'b0;
                end
            end
        endcase
    end
endmodule