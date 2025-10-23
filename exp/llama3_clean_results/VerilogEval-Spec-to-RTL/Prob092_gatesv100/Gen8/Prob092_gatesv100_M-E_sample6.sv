module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] in_reg;
    reg [99:0] out_both_reg;
    reg [99:0] out_any_reg;
    reg [99:0] out_different_reg;

    always @(posedge in) begin
        in_reg <= in;
        for (int i = 0; i < 100; i++) begin
            if (i < 99) begin
                out_both_reg[i] <= in_reg[i] & in_reg[i+1];
            end else begin
                out_both_reg[i] <= 1'b0;
            end
            if (i > 0) begin
                out_any_reg[i] <= in_reg[i] | in_reg[i-1];
            end else begin
                out_any_reg[i] <= 1'b0;
            end
            out_different_reg[i] <= in_reg[i] ^ in_reg[(i+1)%100];
        end
        out_both <= out_both_reg;
        out_any <= out_any_reg;
        out_different <= out_different_reg;
    end

endmodule