module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    // State encoding:
    // A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101
    always @(*) begin
        case (y)
            3'b000: next_y1 = 0;                // A: 0->B(001), 1->A(000), both next states have y[1] = 0
            3'b001: next_y1 = (w == 1'b0) ? 0 : 1; // B: 0->C(010, y1=1), 1->D(011, y1=1)
            3'b010: next_y1 = (w == 1'b0) ? 0 : 1; // C: 0->E(100, y1=0), 1->D(011, y1=1)
            3'b011: next_y1 = (w == 1'b0) ? 1 : 0; // D: 0->F(101, y1=0), 1->A(000, y1=0)
            3'b100: next_y1 = 1;                // E: w=0->E(100, y1=0), w=1->D(011,y1=1), next_y1 depends on w
                                                // Wait, based on transitions, E only transitions when input=1,
                                                // but the problem states E (1) transitions, so w must be 1 to change
                                                // Since E transitions on input=1, w=1 -> D(y1=1), else E(y1=0)
                                                // So we must consider w
            3'b101: next_y1 = (w == 1'b0) ? 1 : 0; // F: 0->C(010,y1=1), 1->D(011,y1=1)
            default: next_y1 = 0;
        endcase
    end

    // Correcting E and F transitions for y1 output:
    // Re-examining from the FSM transitions:
    // E (1) --0--> E (100, y1=0)
    // E (1) --1--> D (011, y1=1)
    // So E's next_y1 = (w==0)? 0 : 1

    // F (1) --0--> C (010,y1=1)
    // F (1) --1--> D (011,y1=1)
    // So F's next_y1 = 1 regardless of w

    always @(*) begin
        case (y)
            3'b100: next_y1 = (w == 1'b0) ? 0 : 1; // E
            3'b101: next_y1 = 1;                    // F
            default: ; // already set above
        endcase
    end

    assign Y1 = y[1];

endmodule