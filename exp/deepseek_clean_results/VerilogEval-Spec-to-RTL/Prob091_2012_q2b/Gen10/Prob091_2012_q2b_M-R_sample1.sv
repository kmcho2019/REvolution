module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    // Default outputs (no state change)
    Y1 = 1'b0;
    Y3 = 1'b0;

    // Explicit state transitions using one-hot encoding
    case (1'b1)
        y[0]: begin // State A
            Y1 = w;  // A→B when w=1
        end
        y[1]: begin // State B
            Y3 = ~w; // B→D when w=0
        end
        y[2]: begin // State C
            Y3 = ~w; // C→D when w=0
        end
        y[4]: begin // State E
            Y3 = ~w; // E→D when w=0
        end
        y[5]: begin // State F
            Y3 = ~w; // F→D when w=0
        end
        // State D (y[3]) has no outputs to set
    endcase
end

endmodule