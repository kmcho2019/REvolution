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

        // State transition logic
        case (1'b1)
            y[0]: begin // State A
                Y1 = w;         // A→B when w=1
                Y3 = ~w;        // A→A when w=0 (but Y3 remains 0)
            end
            y[1]: begin // State B
                Y1 = 1'b0;      // B never sets Y1
                Y3 = ~w;        // B→D when w=0
            end
            y[2]: begin // State C
                Y1 = 1'b0;      // C never sets Y1
                Y3 = ~w;        // C→D when w=0
            end
            y[3]: begin // State D
                Y1 = 1'b0;      // D never sets Y1
                Y3 = 1'b0;       // D transitions don't affect Y3
            end
            y[4]: begin // State E
                Y1 = 1'b0;      // E never sets Y1
                Y3 = ~w;        // E→D when w=0
            end
            y[5]: begin // State F
                Y1 = 1'b0;      // F never sets Y1
                Y3 = ~w;        // F→D when w=0
            end
        endcase
    end

endmodule