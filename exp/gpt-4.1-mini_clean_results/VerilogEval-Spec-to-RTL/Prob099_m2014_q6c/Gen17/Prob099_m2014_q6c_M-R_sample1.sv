module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output reg   Y2,  // next state bit for B (y[1])
    output reg   Y4   // next state bit for D (y[3])
);

    always @(*) begin
        // Default assignments to 0
        Y2 = 1'b0;
        Y4 = 1'b0;

        case (1'b1) // Use one-hot encoding to identify the current state
            y[0]: begin // State A
                // From A: next B (Y2) if w=0; next D (Y4) never from A
                Y2 = (w == 1'b0) ? 1'b1 : 1'b0;
                Y4 = 1'b0;
            end
            y[1]: begin // State B
                // From B: next D (Y4) if w=1; next B (Y2) never from B
                Y2 = 1'b0;
                Y4 = (w == 1'b1) ? 1'b1 : 1'b0;
            end
            y[2]: begin // State C
                // From C: next D (Y4) if w=1; next B (Y2) never from C
                Y2 = 1'b0;
                Y4 = (w == 1'b1) ? 1'b1 : 1'b0;
            end
            y[3]: begin // State D
                // From D: next D (Y4) if w=1; next B (Y2) never from D
                Y2 = 1'b0;
                Y4 = (w == 1'b1) ? 1'b1 : 1'b0;
            end
            y[4]: begin // State E
                // From E: next D (Y4) if w=1; next B (Y2) never from E
                Y2 = 1'b0;
                Y4 = (w == 1'b1) ? 1'b1 : 1'b0;
            end
            y[5]: begin // State F
                // From F: next D (Y4) if w=1; next B (Y2) never from F
                Y2 = 1'b0;
                Y4 = (w == 1'b1) ? 1'b1 : 1'b0;
            end
            default: begin
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
        endcase
    end

endmodule