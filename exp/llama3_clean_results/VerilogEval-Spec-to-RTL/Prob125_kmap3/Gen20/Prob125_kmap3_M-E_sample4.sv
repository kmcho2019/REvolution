module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out
);

// Define a lookup table based on the Karnaugh map
// The table is indexed by the concatenation of a, b, and c
// The values are determined directly from the Karnaugh map

always @(*) begin
    case ({a, b, c})
        3'b000: out = 0; // a=0, b=0, c=0
        3'b001: out = 1; // a=0, b=0, c=1
        3'b010: out = 1; // a=0, b=1, c=0
        3'b011: out = 1; // a=0, b=1, c=1
        3'b100: out = 0; // a=1, b=0, c=0
        3'b101: out = 1; // a=1, b=0, c=1
        3'b110: out = 1; // a=1, b=1, c=0
        3'b111: out = 1; // a=1, b=1, c=1
        default: out = 0; // This should never occur, but included for completeness
    endcase
end

endmodule