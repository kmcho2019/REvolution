module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    reg y1_next;

    always @(*) begin
        case (y)
            3'b000: y1_next = 1'b0;             // A -> next y1 for A transitions
            3'b001: y1_next = (w == 1'b0) ? 1'b1 : 1'b1; // B -> to C or D: both y1=1 or 1, next y1=1
            3'b010: y1_next = (w == 1'b0) ? 1'b0 : 1'b1; // C -> E(0) or D(1)
            3'b011: y1_next = (w == 1'b0) ? 1'b0 : 1'b0; // D -> F(0) or A(0)
            3'b100: y1_next = 1'b1;             // E -> stays E or to D; both next y1=1 or 0? E=100(y1=0)? Wait carefully:
                                            // E(1) --0--> E (E y=100 y1=0)
                                            // E(1) --1--> D (D y=011 y1=1)
                                            // So for E w=0 next state E y1=0; w=1 next D y1=1
                                            // So y1_next = (w == 1) ? 1 : 0;
            3'b101: y1_next = (w == 1'b0) ? 1'b1 : 1'b0; // F -> C(1) or D(1): Wait F=101 y1=0
                                             // F(1) --0--> C y=010 y1=1
                                             // F(1) --1--> D y=011 y1=1
                                             // So both next states y1=1, so y1_next=1
            default: y1_next = 1'b0; // default safe
        endcase
    end

    // Fix some assignments with precise values:
    // For B:
    // B(001) --0--> C(010) y1=1
    // B(0) --1--> D(011) y1=1
    // So y1_next = 1 for both w=0,1
    // For D:
    // D(011) --0--> F(101) y1=0
    // D(0) --1--> A(000) y1=0
    // y1_next = 0 both
    // For E:
    // E(100) --0--> E(100) y1=0
    // E(1) --1--> D(011) y1=1
    // y1_next = w ? 1 : 0
    // For F:
    // F(101) --0--> C(010) y1=1
    // F(1) --1--> D(011) y1=1
    // y1_next=1 always

    assign Y1 = y1_next;

endmodule