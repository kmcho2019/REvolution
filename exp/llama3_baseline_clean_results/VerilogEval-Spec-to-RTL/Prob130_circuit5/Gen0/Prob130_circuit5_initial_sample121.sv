module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

always @(a, b, c, d, e) begin
    case (c[1:0]) // Only the lower two bits of 'c' seem to matter
        2'b00: q = b; // c is 0
        2'b01: q = e; // c is 1
        2'b10: q = a; // c is 2
        2'b11: q = d; // c is 3
        default: q = 4'b1111; // c is greater than 3, assign a default value 'f' to q
    endcase
end

endmodule