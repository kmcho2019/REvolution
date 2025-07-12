module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

wire a_path;
wire b_path;

assign a_path = a & ~sel;
assign b_path = b & sel;
assign out = a_path | b_path;

endmodule