module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,    // d is unused for this implementation
    output reg  q
);

always @(*) begin
    case ({a, b, c})
        3'b000: q = 0;
        3'b001: q = 1;
        3'b010: q = 1;
        3'b011: q = 1;
        3'b100: q = 0;
        3'b101: q = 1;
        3'b110: q = 1;
        3'b111: q = 1;
        default: q = 0;
    endcase
end

endmodule