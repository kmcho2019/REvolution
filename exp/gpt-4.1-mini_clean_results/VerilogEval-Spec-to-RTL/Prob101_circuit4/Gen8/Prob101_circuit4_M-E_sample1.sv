module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

wire ad = a & d;
wire bc = b & c;

assign q = ad | bc;

endmodule