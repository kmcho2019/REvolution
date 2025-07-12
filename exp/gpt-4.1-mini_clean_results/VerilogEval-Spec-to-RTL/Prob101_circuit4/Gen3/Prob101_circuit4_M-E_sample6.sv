module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    case ({b,c})
        2'b00: q = 1'b0;
        2'b01: q = 1'b1;
        2'b10: q = 1'b1;
        2'b11: q = 1'b1;
        default: q = 1'b0; // safe default, though all cases are covered
    endcase
end

endmodule