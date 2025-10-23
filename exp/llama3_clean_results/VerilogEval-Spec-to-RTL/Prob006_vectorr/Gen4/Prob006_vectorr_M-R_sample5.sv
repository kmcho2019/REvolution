module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    reg [7:0] out_reg;

    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            out_reg[7-i] = in[i];
        end
        out = out_reg;
    end

endmodule