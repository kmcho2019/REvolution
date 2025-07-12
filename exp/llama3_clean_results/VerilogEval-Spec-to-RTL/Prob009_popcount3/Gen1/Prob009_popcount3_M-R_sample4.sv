module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    reg [1:0] out_reg;

    always @(*) begin
        out_reg = in[0] + in[1] + in[2];
    end

    assign out = out_reg;

endmodule