// Novel implementation of the TopModule using a lookup table approach
module TopModule(
    input  a,
    input  b,
    output q
);

always @(*) begin
    case ({a, b})
        2'b00: q = 1'b0;
        2'b01: q = 1'b0;
        2'b10: q = 1'b0;
        2'b11: q = 1'b1;
        default: q = 1'b0;
    endcase
end

endmodule