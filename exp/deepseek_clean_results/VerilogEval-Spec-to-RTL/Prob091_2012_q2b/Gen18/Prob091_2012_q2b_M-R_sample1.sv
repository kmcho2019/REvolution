module TopModule (
    input [5:0] y,    // One-hot encoded state: y[5:0] = FEDCBA
    input w,          // Input signal
    output reg Y1,     // Next state for y[1] (state B)
    output reg Y3      // Next state for y[3] (state D)
);

    // State encoding (one-hot):
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        case (1'b1)  // One-hot case statement
            y[0]: begin // State A
                Y1 = w;  // A --1--> B
                Y3 = 1'b0;
            end
            y[1]: begin // State B
                Y1 = 1'b0;
                Y3 = ~w; // B --0--> D
            end
            y[2]: begin // State C
                Y1 = 1'b0;
                Y3 = ~w; // C --0--> D
            end
            y[3]: begin // State D
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
            y[4]: begin // State E
                Y1 = 1'b0;
                Y3 = ~w; // E --0--> D
            end
            y[5]: begin // State F
                Y1 = 1'b0;
                Y3 = ~w; // F --0--> D
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule