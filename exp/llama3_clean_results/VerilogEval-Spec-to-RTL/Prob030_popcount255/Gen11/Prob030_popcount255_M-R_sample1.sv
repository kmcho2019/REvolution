module TopModule(
    input [254:0] in,
    output [7:0] out
);

    reg [7:0] out_reg;

    always @(*)
        out_reg = $countones(in);

    assign out = out_reg;

endmodule