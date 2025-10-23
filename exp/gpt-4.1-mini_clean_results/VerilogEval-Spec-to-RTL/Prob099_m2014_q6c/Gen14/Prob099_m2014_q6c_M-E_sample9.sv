module TopModule (
    input  [5:0] y,  // one-hot encoded current state: A..F = y[0]..y[5]
    input        w,
    output reg   Y1, // next state signal for y[1] (state B)
    output reg   Y3  // next state signal for y[3] (state D)
);

always @(*) begin
    // Default outputs
    Y1 = 1'b0;
    Y3 = 1'b0;

    case (1'b1) // one-hot decode y
        y[0]: begin // State A
            // From A: 0 -> B (y[1]), 1 -> A (no output for y[3])
            if (w == 1'b0)
                Y1 = 1'b1;
            // no Y3 asserted
        end
        y[1]: begin // State B
            // From B: 0 -> C (y[2]), 1 -> D (y[3])
            if (w == 1'b1)
                Y3 = 1'b1;
            // no Y1
        end
        y[2]: begin // State C
            // From C: 0 -> E (y[4]), 1 -> D (y[3])
            if (w == 1'b1)
                Y3 = 1'b1;
            // no Y1
        end
        y[3]: begin // State D
            // From D: 0 -> F (y[5]), 1 -> A (y[0])
            // Neither next states correspond to y[1] or y[3], so no outputs
        end
        y[4]: begin // State E
            // From E: 0 -> E (y[4]), 1 -> D (y[3])
            if (w == 1'b1)
                Y3 = 1'b1;
            // no Y1
        end
        y[5]: begin // State F
            // From F: 0 -> C (y[2]), 1 -> D (y[3])
            if (w == 1'b1)
                Y3 = 1'b1;
            // no Y1
        end
        default: begin
            // No valid state, outputs remain 0
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
    endcase
end

endmodule