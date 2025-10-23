module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    // Combinational LUT logic based only on b and c
    always @(*) begin
        case ({b, c})
            2'b00: q = 1'b0;
            2'b01: q = 1'b1;
            2'b10: q = 1'b1;
            2'b11: q = 1'b1;
            default: q = 1'b0;
        endcase
    end
endmodule