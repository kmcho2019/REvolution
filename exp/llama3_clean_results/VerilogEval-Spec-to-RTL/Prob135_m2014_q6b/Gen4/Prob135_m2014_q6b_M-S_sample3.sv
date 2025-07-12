module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output reg Y1;

    always @(*) begin
        case (y)
            3'b000: Y1 = 0;  // A to A or B, y[1] is always 0
            3'b001: Y1 = w? 1 : 0;  // B to D or C, y[1] is 1 if w, 0 if not w
            3'b010: Y1 = 1;  // C to E or D, y[1] is always 1
            3'b011: Y1 = w? 0 : 1;  // D to A or D, y[1] is 0 if w, 1 if not w
            3'b100: Y1 = 1;  // E to E or D, y[1] is always 1
            3'b101: Y1 = w? 1 : 0;  // F to C or D, y[1] is 0 if not w, 1 if w
            default: Y1 = 0;
        endcase
    end
endmodule