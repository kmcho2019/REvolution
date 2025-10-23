module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire nsel;
wire and_a;
wire and_b;

assign nsel  = ~sel;
assign and_a = a & nsel;
assign and_b = b & sel;
assign out   = and_a | and_b;

endmodule