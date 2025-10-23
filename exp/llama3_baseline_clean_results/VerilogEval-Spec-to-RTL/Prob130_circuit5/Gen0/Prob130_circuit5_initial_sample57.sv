module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

always @(a, b, c, d, e) begin
    case(c)
        4'b0000: q = b; // c is 0, q takes the value of b
        4'b0001: q = e; // c is 1, q takes the value of e
        4'b0010: q = a; // c is 2, q takes the value of a
        4'b0011: q = d; // c is 3, q takes the value of d
        default: q = 4'b1111; // c is greater than 3, q takes the value 'f'
    endcase
end

endmodule