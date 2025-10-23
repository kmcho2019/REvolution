module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored here
    output reg out
);

always @(*) begin
    case ({c,b,a}) // order c,b,a for easier mapping
        3'b000: out = 0; // from K-map 00 00: 0 (using don't-care d=0)
        3'b001: out = 1; // 00 01: 1
        3'b010: out = 1; // 00 10: 1
        3'b011: out = 1; // 00 11: 1
        3'b100: out = 1; // 01 00: 1 (chose 1 for don't-care)
        3'b101: out = 1; // 01 01: 1 (chose 1 for don't-care)
        3'b110: out = 1; // 01 10: 1
        3'b111: out = 1; // 01 11: 1
        default: out = 0; // cover all other states (should not occur)
    endcase
end

endmodule