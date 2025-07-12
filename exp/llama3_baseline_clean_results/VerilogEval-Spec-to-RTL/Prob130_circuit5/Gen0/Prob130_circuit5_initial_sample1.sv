module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

always @(*) begin
    case (c)
        0: q = b;
        1: q = e;
        2: q = a;
        3: q = d;
        default: q = 4'b1111; // Assigning all ones for c values greater than 3
    endcase
end

endmodule