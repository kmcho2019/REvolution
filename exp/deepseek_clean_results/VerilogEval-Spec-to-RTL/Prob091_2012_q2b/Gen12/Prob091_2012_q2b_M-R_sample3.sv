module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        // State transition logic using one-hot encoding
        casez (y)
            6'b000001: begin // State A
                Y1 = w;       // A->B when w=1
                Y3 = 1'b0;    // No transition to D
            end
            6'b000010: begin // State B
                Y3 = ~w;      // B->D when w=0
            end
            6'b000100: begin // State C
                Y3 = ~w;     // C->D when w=0
            end
            6'b001000: begin // State D
                // No Y1 or Y3 transitions from D
            end
            6'b010000: begin // State E
                Y3 = ~w;     // E->D when w=0
            end
            6'b100000: begin // State F
                Y3 = ~w;     // F->D when w=0
            end
            default: begin
                // Handle unexpected states (all zeros or multiple bits)
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule