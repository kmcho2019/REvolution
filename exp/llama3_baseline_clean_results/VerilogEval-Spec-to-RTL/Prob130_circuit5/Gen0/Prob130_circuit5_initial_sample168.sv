module TopModule(
    input [3:0] a, b, c, d, e,
    output [3:0] q
);

always @(*) begin
    case (c)
        4'b0000: q = b;  // When c is 0, q = b
        4'b0001: q = e;  // When c is 1, q = e
        4'b0010: q = a;  // When c is 2, q = a
        4'b0011: q = d;  // When c is 3, q = d
        default: q = 4'b1111;  // For any other value of c, q = 'f' (1111)
    endcase
end

endmodule