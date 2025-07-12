module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    reg [2:0] next_y;

    always @(*) begin
        case (y)
            3'b000: next_y = (w == 1'b0) ? 3'b001 : 3'b000; // A->B or A->A
            3'b001: next_y = (w == 1'b0) ? 3'b010 : 3'b011; // B->C or B->D
            3'b010: next_y = (w == 1'b0) ? 3'b100 : 3'b011; // C->E or C->D
            3'b011: next_y = (w == 1'b0) ? 3'b101 : 3'b000; // D->F or D->A
            3'b100: next_y = (w == 1'b0) ? 3'b100 : 3'b011; // E->E or E->D
            3'b101: next_y = (w == 1'b0) ? 3'b010 : 3'b011; // F->C or F->D
            default: next_y = 3'b000; // default to A
        endcase
        Y1 = next_y[1];
    end

endmodule