module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

always @(*) begin
    case ({c, d})
        2'b00: out = (a ^ b); // When c and d are 00, out is 1 if a and b are different (01 or 10)
        2'b01: out = ~(a ^ b); // When c and d are 01, out is 1 if a and b are the same (00 or 11)
        2'b11: out = (a ^ b); // When c and d are 11, out is 1 if a and b are different (01 or 10)
        2'b10: out = ~(a ^ b); // When c and d are 10, out is 1 if a and b are the same (00 or 11)
    endcase
end

endmodule