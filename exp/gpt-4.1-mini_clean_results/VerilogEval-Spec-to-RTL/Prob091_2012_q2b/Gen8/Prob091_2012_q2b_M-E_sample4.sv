module TopModule (
    input  [5:0] y,  // one-hot encoded state
    input        w,
    output reg   Y1,
    output reg   Y3
);
    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;
        
        case (1'b1)  // One-hot encoding: check which bit is set
            y[0]: begin // State A
                // A(0) --1--> B
                Y1 = w;
                // No transition to D from A, so Y3=0
            end
            y[1]: begin // State B
                // B(0) --0--> D
                Y3 = ~w;
                // No transition to B itself (Y1) from B
            end
            y[2]: begin // State C
                // C(0) --0--> D
                Y3 = ~w;
                // No transition to B (Y1)
            end
            y[3]: begin // State D
                // D(0) --1--> F
                // D(0) --0--> A
                // No direct transition to B or D input
            end
            y[4]: begin // State E
                // E(1) --0--> D
                Y3 = ~w;
                // No Y1 input
            end
            y[5]: begin // State F
                // F(1) --0--> D
                Y3 = ~w;
                // No Y1 input
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end
endmodule