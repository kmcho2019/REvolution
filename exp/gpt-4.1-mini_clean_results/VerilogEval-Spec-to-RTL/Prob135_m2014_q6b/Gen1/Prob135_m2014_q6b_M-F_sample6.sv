module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    reg y1_next;

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    always @(*) begin
        // Default
        y1_next = 1'b0;

        case (y)
            3'b000: // A
                // A->B (w=0) y=001 y1=0, A->A (w=1) y=000 y1=0
                y1_next = 1'b0;
            3'b001: // B
                // B->C or D next states, both y1=1
                y1_next = 1'b1;
            3'b010: // C
                // w=0->E(100) y1=0
                // w=1->D(011) y1=1
                y1_next = w ? 1'b1 : 1'b0;
            3'b011: // D
                // D->F(101) or A(000), both y1=0
                y1_next = 1'b0;
            3'b100: // E
                // w=0->E(100) y1=0
                // w=1->D(011) y1=1
                y1_next = w ? 1'b1 : 1'b0;
            3'b101: // F
                // F->C(010) or D(011), both y1=1
                y1_next = 1'b1;
            default:
                y1_next = 1'b0;
        endcase
    end

    assign Y1 = y1;

endmodule