module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

wire not_b;
wire not_c;
wire and_nots;

assign not_b = ~b;
assign not_c = ~c;
assign and_nots = not_b & not_c;
assign q = ~and_nots;

endmodule