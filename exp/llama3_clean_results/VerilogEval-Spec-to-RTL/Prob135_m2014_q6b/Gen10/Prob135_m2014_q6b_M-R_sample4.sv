module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg next_y1;

    always @(*) begin
        case ({y[2], y[1], y[0]})
            3'b000: next_y1 = w ? 0 : 0; // A to B or A to A
            3'b001: next_y1 = w ? 1 : 1; // B to D or B to C
            3'b010: next_y1 = ~w ? 1 : 1; // C to E or C to D
            3'b011: next_y1 = w ? 0 : 1; // D to A or D to F
            3'b100: next_y1 = w ? 1 : 1; // E to D or E to E
            3'b101: next_y1 = w ? 1 : 1; // F to D or F to C
            default: next_y1 = 1'bx;
        endcase
    end

    assign Y1 = y[1];

endmodule