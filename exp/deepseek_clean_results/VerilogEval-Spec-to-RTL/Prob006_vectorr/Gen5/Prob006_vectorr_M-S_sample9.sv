module TopModule (
    input [7:0] in,
    output [7:0] out
);

    assign out = {in[0+:8]};

endmodule