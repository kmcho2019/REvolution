module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Internal next state signals
    reg next_Y1;
    reg next_Y3;

    always @(*) begin
        // Default assignments
        next_Y1 = 1'b0;
        next_Y3 = 1'b0;

        // State transition logic
        case (1'b1) // One-hot case statement
            y[0]: begin // State A
                next_Y1 = w;         // A->B when w=1
                next_Y3 = ~w & ~y[3]; // A->D when w=0
            end
            y[1]: begin // State B
                next_Y3 = ~w;       // B->D when w=0
            end
            y[2]: begin // State C
                next_Y3 = ~w;       // C->D when w=0
            end
            y[3]: begin // State D
                // No Y1/Y3 outputs generated from D
            end
            y[4]: begin // State E
                next_Y3 = ~w;       // E->D when w=0
            end
            y[5]: begin // State F
                next_Y3 = ~w;       // F->D when w=0
            end
        endcase
    end

    // Continuous output assignments
    assign Y1 = next_Y1;
    assign Y3 = next_Y3;

endmodule