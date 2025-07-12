module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0; // A: next y1 depends on transitions but only y[1] output requested is from current state
            3'b001: next_y1 = (w == 1'b1) ? 1'b1 : 1'b0; // B: 0->C(y=010),1->D(y=011), C and D have y1=1 and 1
            3'b010: next_y1 = (w == 1'b1) ? 1'b1 : 1'b0; // C: 0->E(100,y1=0),1->D(011,y1=1)
            3'b011: next_y1 = (w == 1'b1) ? 1'b0 : 1'b1; // D: 0->F(101,y1=0),1->A(000,y1=0)
            3'b100: next_y1 = 1'b0;                       // E: stays or goes to D, y1 always 0 or 1; but next y1=0 (E=100), D=011(y1=1)
            3'b101: next_y1 = (w == 1'b1) ? 1'b1 : 1'b1; // F: 0->C(010,y1=1),1->D(011,y1=1)
            default: next_y1 = 1'b0;
        endcase
    end

    // The problem states output Y1 = y[1], i.e. current y[1], so assign directly
    assign Y1 = y[1];

endmodule