module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, ignored in logic
    output reg out
);

// Implement logic as a combinational ROM using a case statement on {a,b,c}.
// d is don't-care and not used.

// Truth table derived from Karnaugh map and simplification:
// a b c | out
// 0 0 0 | 0 (00 00 is 0)
// 0 0 1 | 1 (a=0,b=0,c=1)
// 0 1 0 | 0 (a=0,b=1,c=0)
// 0 1 1 | 0 (a=0,b=1,c=1)
// 1 x x | 1 (any a=1 yields out=1 due to OR with a)

// Fill other entries as per Karnaugh map minimal logic: out = a | (c & ~b)

always @(*) begin
    case ({a,b,c})
        3'b000: out = 1'b0; // a=0,b=0,c=0
        3'b001: out = 1'b1; // a=0,b=0,c=1
        3'b010: out = 1'b0; // a=0,b=1,c=0
        3'b011: out = 1'b0; // a=0,b=1,c=1
        3'b100: out = 1'b1; // a=1,b=0,c=0
        3'b101: out = 1'b1; // a=1,b=0,c=1
        3'b110: out = 1'b1; // a=1,b=1,c=0
        3'b111: out = 1'b1; // a=1,b=1,c=1
        default: out = 1'b0; // default fallback (should not occur)
    endcase
end

endmodule