module TopModule (
    input [5:0] y,  // One-hot encoded state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,        // State machine input
    output reg Y1,  // Next state for y[1] (state B)
    output reg Y3   // Next state for y[3] (state D)
);

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;
        
        // State transition logic using casez for one-hot matching
        casez (y)
            6'b000001: begin // State A
                Y1 = w;      // A->B when w=1
                Y3 = 1'b0;
            end
            6'b000010: begin // State B
                Y3 = ~w;     // B->D when w=0
            end
            6'b000100: begin // State C
                Y3 = ~w;     // C->D when w=0
            end
            6'b001000: begin // State D
                // No outputs set - handled by default
            end
            6'b010000: begin // State E
                Y3 = ~w;    // E->D when w=0
            end
            6'b100000: begin // State F
                Y3 = ~w;     // F->D when w=0
            end
            default: begin   // Handle undefined states
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule