module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state definitions
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // Optimized Y1 (next state B) logic:
    // Only transitions from A when w=1
    assign Y1 = (y == A) & w;

    // Optimized Y3 (next state D) logic:
    // Transitions from B/C/E/F when w=0, using parallel comparison
    assign Y3 = ~w & (
                (y == B) |
                (y == C) |
                (y == E) |
                (y == F)
                );

    // Alternative implementation using casez for potentially better synthesis:
    /*
    reg next_Y1, next_Y3;
    always @(*) begin
        casez (y)
            A: begin
                next_Y1 = w;
                next_Y3 = 1'b0;
            end
            B: begin
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            C: begin
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            E: begin
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            F: begin
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            default: begin  // D or invalid states
                next_Y1 = 1'b0;
                next_Y3 = 1'b0;
            end
        endcase
    end
    assign Y1 = next_Y1;
    assign Y3 = next_Y3;
    */

endmodule