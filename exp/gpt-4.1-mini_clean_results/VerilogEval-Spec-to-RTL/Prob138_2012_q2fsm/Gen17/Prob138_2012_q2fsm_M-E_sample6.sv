module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding
    // Each bit represents a state; only one bit set at a time
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic using one-hot encoding
    always @(*) begin
        // Default: no next state (all zeros) - safety fallback
        next_state = 6'b0;

        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // recovery state on illegal encoding
        endcase
    end

    // Output logic: z = 1 in states E or F
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule