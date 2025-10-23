module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;               // A -> y[1] next = 0
            3'b001: next_y1 = (w == 1'b0) ? 1'b0 : 1'b1; // B: 0->C(y=010): y[1]=1, 1->D(y=011): y[1]=1
            3'b010: next_y1 = (w == 1'b0) ? 1'b0 : 1'b1; // C: 0->E(y=100): y[1]=0, 1->D(y=011): y[1]=1
            3'b011: next_y1 = (w == 1'b0) ? 1'b1 : 1'b0; // D: 0->F(y=101): y[1]=0, 1->A(y=000): y[1]=0
            3'b100: next_y1 = 1'b1;               // E: regardless of w, y[1]=1 as E and D have y[1]=1
            3'b101: next_y1 = (w == 1'b0) ? 1'b1 : 1'b1; // F: both next states have y[1] = 1
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule