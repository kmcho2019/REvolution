module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);

    // States encoding: A=000, B=001, C=010, D=011, E=100, F=101
    // Only next-state logic for y[1] bit is implemented here.
    // Output Y1 is current y[1].

    reg y1_next;

    always @(*) begin
        case (y)
            3'b000: y1_next = 1'b0;             // A->B or A->A: y1=0
            3'b001: y1_next = 1'b1;             // B->C or B->D: y1=1
            3'b010: y1_next = (w == 1'b0) ? 1'b0 : 1'b1; // C->E(0) or C->D(1)
            3'b011: y1_next = 1'b0;             // D->F or D->A: y1=0
            3'b100: y1_next = (w == 1'b0) ? 1'b0 : 1'b1; // E->E(0) or E->D(1)
            3'b101: y1_next = 1'b1;             // F->C or F->D: y1=1
            default: y1_next = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule