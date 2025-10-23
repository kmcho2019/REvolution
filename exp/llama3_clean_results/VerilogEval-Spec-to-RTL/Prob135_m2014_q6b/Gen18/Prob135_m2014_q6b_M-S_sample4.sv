module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    wire next_y1;

    always @(*) begin
        case (y)
            STATE_A: next_y1 = 0; // A -> A or B, y[1] is always 0
            STATE_B: next_y1 = ~w; // B -> C or D, y[1] is 0 for C, 1 for D
            STATE_C: next_y1 = ~w; // C -> E or D, y[1] is 0 for E, 1 for D
            STATE_D: next_y1 = ~w; // D -> F or A, y[1] is 1 for F, 0 for A
            STATE_E: next_y1 = w; // E -> E or D, y[1] is 1 for D, 0 for E (but E doesn't go to a state with y[1]=0)
            STATE_F: next_y1 = ~w; // F -> C or D, y[1] is 0 for C, 1 for D
            default: next_y1 = 0;
        endcase
    end

    assign Y1 = next_y1;

endmodule