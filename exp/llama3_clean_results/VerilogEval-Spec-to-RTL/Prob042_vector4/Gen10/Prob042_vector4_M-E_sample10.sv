module SignExtend(
    input [7:0] in,
    output [31:0] out
);

    assign out = (in[7]) ? {24'hFFFFFF, in} : {24'h0, in};

endmodule

module TopModule (
    input [7:0] in,
    output [31:0] out
);

    SignExtend se (.in(in), .out(out));

endmodule