module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

wire [8:0] temp;

assign temp = {a[7], a} + {b[7], b};
assign s = temp[7:0];
assign overflow = (a[7] == b[7]) && (a[7] != temp[8]);

endmodule