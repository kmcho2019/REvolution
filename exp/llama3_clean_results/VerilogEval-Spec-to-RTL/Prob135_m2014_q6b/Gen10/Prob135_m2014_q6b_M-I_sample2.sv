module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg next_y1;

    always @(*) begin
        case ({y[2], y[1], y[0]})
            3'b000: next_y1 = w? 1'b0 : 1'b0; // A to B (y[1] = 0) or A to A (y[1] = 0)
            3'b001: next_y1 = w? 1'b1 : 1'b1; // B to C (y[1] = 1) or B to D (y[1] = 1)
            3'b010: next_y1 = w? 1'b1 : 1'b1; // C to E (y[1] = 1) or C to D (y[1] = 1)
            3'b011: next_y1 = w? 1'b0 : 1'b1; // D to A (y[1] = 0) or D to F (y[1] = 1)
            3'b100: next_y1 = w? 1'b1 : 1'b1; // E to D (y[1] = 1) or E to E (y[1] = 1)
            3'b101: next_y1 = w? 1'b0 : 1'b1; // F to C (y[1] = 1) or F to D (y[1] = 1)
            default: next_y1 = 1'bx;
        endcase
    end

    assign Y1 = y[1];

endmodule