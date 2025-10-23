module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Default assignments
        Y1 = 1'b0;
        Y3 = 1'b0;

        case (1'b1) // "one-hot" decoding by detecting which bit of y is set
            y[0]: begin // State A
                Y1 = w;   // A --w=1--> B
                Y3 = 1'b0;
            end
            y[1]: begin // State B
                Y1 = 1'b0;
                Y3 = ~w;  // B --w=0--> D
            end
            y[2]: begin // State C
                Y1 = 1'b0;
                Y3 = ~w;  // C --w=0--> D
            end
            y[3]: begin // State D
                Y1 = 1'b0;
                Y3 = 1'b0; // no direct transition to D from D
            end
            y[4]: begin // State E
                Y1 = 1'b0;
                Y3 = ~w;  // E --w=0--> D
            end
            y[5]: begin // State F
                Y1 = 1'b0;
                Y3 = ~w;  // F --w=0--> D
            end
            default: begin
                // If no valid state is active, outputs remain 0
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule