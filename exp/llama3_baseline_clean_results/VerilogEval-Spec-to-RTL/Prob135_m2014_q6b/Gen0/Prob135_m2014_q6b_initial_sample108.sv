module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

// assign output Y1 to y[1]
assign Y1 = y[1];

// next-state logic for y[1]
wire y1_next;

// state A (000) to state A (000) or B (001) based on w
// state B (001) to state C (010) or D (011) based on w
// state C (010) to state E (100) or D (011) based on w
// state D (011) to state F (110) or A (000) based on w
// state E (100) stays in E (100) when w is 1 and goes to D (011) when w is 0
// state F (110) goes to C (010) when w is 0 and to D (011) when w is 1

always @(*)
begin
    case (y)
        3'b000: y1_next = w;  // A to B
        3'b001: y1_next = 1'b0;  // B to C or D, y[1] is 0 in both cases
        3'b010: y1_next = ~w;  // C to E or D
        3'b011: y1_next = w;  // D to F or A
        3'b100: y1_next = w;  // E stays in E or goes to D
        3'b101: y1_next = ~w;  // F goes to C or D
        default: y1_next = 1'bx;  // unknown state
    endcase
end

endmodule