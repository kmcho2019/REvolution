module TopModule(
    input [99:0] a,
    input [99:0] b,
    input sel,
    output [99:0] out
);

wire [99:0] sel_a;
wire [99:0] sel_b;
wire [99:0] not_sel;

assign not_sel = ~sel;
assign sel_a = a & {100{not_sel}};
assign sel_b = b & {100{sel}};
assign out = sel_a | sel_b;

endmodule