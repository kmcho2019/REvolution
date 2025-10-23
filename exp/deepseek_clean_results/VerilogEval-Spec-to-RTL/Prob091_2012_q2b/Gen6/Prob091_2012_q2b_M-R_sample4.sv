module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

    // Next state computation
    always @(*) begin
        case (1'b1)  // Synopsys parallel_case (implied by one-hot)
            y[0]: begin // State A
                Y1 = w;      // Next state could be B (y[1]) if w=1
                Y3 = 1'b0;   // Not going to D (y[3]) directly from A
            end
            y[1]: begin // State B
                Y1 = 1'b0;   // Not staying in B
                Y3 = ~w;     // Next state could be D (y[3]) if w=0
            end
            y[2]: begin // State C
                Y1 = 1'b0;
                Y3 = ~w;     // Next state could be D (y[3]) if w=0
            end
            y[3]: begin // State D
                Y1 = 1'b0;
                Y3 = ~w;     // Next state could be A (y[0]) if w=0
            end
            y[4]: begin // State E
                Y1 = 1'b0;
                Y3 = ~w;     // Next state could be D (y[3]) if w=0
            end
            y[5]: begin // State F
                Y1 = 1'b0;
                Y3 = ~w;     // Next state could be D (y[3]) if w=0
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule