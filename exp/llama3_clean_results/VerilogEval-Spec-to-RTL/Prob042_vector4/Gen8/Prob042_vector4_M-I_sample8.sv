module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    assign out = (in[7] == 1'b1) ? {24'hFFFFFF, in} : {24'h0, in};
endmodule