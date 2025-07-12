module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    reg [3:0] out_both_reg;
    reg [3:0] out_any_reg;
    reg [3:0] out_different_reg;
    integer i;

    always @(*) begin
        for (i = 0; i < 4; i++) begin
            if (i < 3) begin
                out_both_reg[i] = in[i] & in[i+1];
            end else begin
                out_both_reg[i] = 1'b0;
            end

            if (i == 0) begin
                out_any_reg[i] = in[i];
            end else begin
                out_any_reg[i] = in[i] | in[i-1];
            end

            if (i == 3) begin
                out_different_reg[i] = in[i] ^ in[0];
            end else begin
                out_different_reg[i] = in[i] ^ in[i+1];
            end
        end
        out_both = out_both_reg;
        out_any = out_any_reg;
        out_different = out_different_reg;
    end
endmodule