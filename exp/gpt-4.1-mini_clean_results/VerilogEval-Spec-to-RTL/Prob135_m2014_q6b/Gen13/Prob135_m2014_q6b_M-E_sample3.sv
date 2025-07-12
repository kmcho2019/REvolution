module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode current state into one-hot signals
    wire state_A = (y == 3'b000);
    wire state_B = (y == 3'b001);
    wire state_C = (y == 3'b010);
    wire state_D = (y == 3'b011);
    wire state_E = (y == 3'b100);
    wire state_F = (y == 3'b101);

    reg [2:0] next_y;

    always @(*) begin
        case (1'b1) // priority encoder style
            state_A: next_y = w ? 3'b000 : 3'b001; // A->A or A->B
            state_B: next_y = w ? 3'b011 : 3'b010; // B->D or B->C
            state_C: next_y = w ? 3'b011 : 3'b100; // C->D or C->E
            state_D: next_y = w ? 3'b000 : 3'b101; // D->A or D->F
            state_E: next_y = w ? 3'b011 : 3'b100; // E->D or E->E
            state_F: next_y = w ? 3'b011 : 3'b010; // F->D or F->C
            default: next_y = 3'b000; // default to A if unknown
        endcase
    end

    assign Y1 = next_y[1];

endmodule