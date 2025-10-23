module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000: Y1 = w? 0 : 1; // A (0) --> B or A
        3'b001: Y1 = w? 1 : 0; // B (0) --> C or D
        3'b010: Y1 = w? 1 : 0; // C (0) --> E or D
        3'b011: Y1 = w? 0 : 1; // D (0) --> F or A
        3'b100: Y1 = w? 0 : 1; // E (1) --> E or D
        3'b101: Y1 = w? 0 : 1; // F (1) --> C or D
        default: Y1 = 0;
    endcase
end

endmodule