module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Next state bit 1 logic according to the state transition table
    // y[2:0] current state, w input
    // States:
    // A=000, B=001, C=010, D=011, E=100, F=101
    // We'll implement next y[1] only.

    // Extract current bits for readability
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    reg y1_next;

    always @* begin
        case (y)
            3'b000: y1_next = y1;        // A (000) -- next depends on transitions, but since y1=0 and A->A or B, from table:
                                        // A(000):
                                        // w=0->B(001) y1=0
                                        // w=1->A(000) y1=0
                                        // next y1 = 0
            3'b001: y1_next = 1'b1;      // B(001)
                                        // B(001) --0--> C(010), y1=1
                                        // B(001) --1--> D(011), y1=1
            3'b010: y1_next = 1'b1;      // C(010)
                                        // C(010) --0--> E(100) y1=0
                                        // C(010) --1--> D(011) y1=1
                                        // next y1 depends on w:
                                        // if w=0 -> E(100) y1=0
                                        // if w=1 -> D(011) y1=1
            3'b011: y1_next = 1'b1;      // D(011)
                                        // D(011) --0--> F(101) y1=0
                                        // D(011) --1--> A(000) y1=0
                                        // both 0 for y1, so y1_next=0 actually
                                        // previous assessment was wrong, set correct
            3'b100: y1_next = 1'b0;      // E(100)
                                        // E(100) --0--> E(100) y1=0
                                        // E(100) --1--> D(011) y1=1
                                        // depends on w
            3'b101: y1_next = 1'b1;      // F(101)
                                        // F(101) --0--> C(010) y1=1
                                        // F(101) --1--> D(011) y1=1
            default: y1_next = 1'b0;     // default safe
        endcase
    end

    // Since y1_next depends on w for states 010 and 100, let's express it fully with conditions:
    always @* begin
        case (y)
            3'b000: y1_next = 1'b0;               // A(000)
            3'b001: y1_next = 1'b1;               // B(001)
            3'b010: y1_next = w ? 1'b1 : 1'b0;   // C(010)
            3'b011: y1_next = 1'b0;               // D(011)
            3'b100: y1_next = w ? 1'b1 : 1'b0;   // E(100)
            3'b101: y1_next = 1'b1;               // F(101)
            default: y1_next = 1'b0;
        endcase
    end

    assign Y1 = y1;

endmodule