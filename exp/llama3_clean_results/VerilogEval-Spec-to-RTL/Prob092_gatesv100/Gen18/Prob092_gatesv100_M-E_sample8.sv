module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] shifted_in;
    reg [99:0] out_both_reg;
    reg [99:0] out_any_reg;
    reg [99:0] out_different_reg;

    always @(*) begin
        shifted_in = in;
        for (int i = 0; i < 100; i++) begin
            out_both_reg[i] = (i < 99) ? shifted_in[i] & shifted_in[i+1] : 1'b0;
            out_any_reg[i] = (i > 0) ? shifted_in[i] | shifted_in[i-1] : 1'b0;
            out_different_reg[i] = shifted_in[i] ^ shifted_in[(i+1)%100];
        end
    end

    assign out_both = out_both_reg;
    assign out_any = out_any_reg;
    assign out_different = out_different_reg;

endmodule