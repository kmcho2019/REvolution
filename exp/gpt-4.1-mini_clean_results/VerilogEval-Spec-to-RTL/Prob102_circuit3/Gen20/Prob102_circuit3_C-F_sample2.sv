module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    wire ab_or = a | b;
    wire cd_or = c | d;
    assign q = ab_or & cd_or;
endmodule