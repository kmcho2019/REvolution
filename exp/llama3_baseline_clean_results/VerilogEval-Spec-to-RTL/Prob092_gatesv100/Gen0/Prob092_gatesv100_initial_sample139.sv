module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

integer i;
reg [99:0] out_both_reg, out_any_reg, out_different_reg;

always @(*) begin
    out_both_reg = 0;
    out_any_reg = 0;
    out_different_reg = 0;

    for (i = 0; i < 100; i++) begin
        if (i == 99) begin
            // Handle the case where we are at the most significant bit
            out_both_reg[i] = 0;
            out_any_reg[i] = in[i];
            out_different_reg[i] = in[i] != in[0];
        end else if (i == 0) begin
            // Handle the case where we are at the least significant bit
            out_any_reg[i] = 0;
            out_both_reg[i] = in[i] && in[i+1];
            out_different_reg[i] = in[i] != in[99];
        end else begin
            out_both_reg[i] = in[i] && in[i+1];
            out_any_reg[i] = in[i] || in[i-1];
            out_different_reg[i] = in[i] != in[i+1];
        end
    end

    out_both <= out_both_reg;
    out_any <= out_any_reg;
    out_different <= out_different_reg;
end

endmodule