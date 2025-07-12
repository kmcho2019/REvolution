module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output reg  out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

wire ab_or = a | b;
wire na_nb_or = na | nb;

always @(*) begin
    if ((nc & nd & na_nb_or) |
        (nc & d  & nb)       |
        (c  & nd & na)       |
        (c  & d  & ab_or))
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule