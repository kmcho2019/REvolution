module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    assign out = (in[7] == 1'b1) ? {24'd-1, in} : {24'd0, in};

endmodule