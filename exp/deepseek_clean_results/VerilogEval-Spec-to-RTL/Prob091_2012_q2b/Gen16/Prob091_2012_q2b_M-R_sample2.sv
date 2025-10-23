module TopModule (
    input [5:0] y,    // One-hot encoded state: y[5:0] = FEDCBA
    input w,          // Input signal
    output reg Y1,    // Next state for y[1] (state B)
    output reg Y3     // Next state for y[3] (state D)
);

    // Explicit state definitions using localparam
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        case (1'b1)  // Synthesis will optimize this to parallel case
            y[0]: begin // State A
                Y1 = w;  // A -> B when w=1
                Y3 = 1'b0;
            end
            y[1]: begin // State B
                Y3 = ~w; // B -> D when w=0
            end
            y[2]: begin // State C
                Y3 = ~w; // C -> D when w=0
            end
            y[4]: begin // State E
                Y3 = ~w; // E -> D when w=0
            end
            y[5]: begin // State F
                Y3 = ~w; // F -> D when w=0
            end
            // State D doesn't affect Y1 or Y3 outputs
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule