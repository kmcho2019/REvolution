module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

wire next_y1;

always @(*)
begin
    case (y)
        3'b000: next_y1 = w; // A
        3'b001: next_y1 = w; // B
        3'b010: next_y1 = w; // C
        3'b011: next_y1 = 1'b1; // D
        3'b100: next_y1 = 1'b1; // E
        3'b101: next_y1 = 1'b1; // F
        default: next_y1 = 1'bx;
    endcase
end

assign Y1 = y[1];

// To make it work, you should also define the logic for y[0] and y[2]
// and use them to update y[1] accordingly in the next clock cycle
// but since the problem asks only for the next-state logic of y[1],
// we are not doing that here.

endmodule