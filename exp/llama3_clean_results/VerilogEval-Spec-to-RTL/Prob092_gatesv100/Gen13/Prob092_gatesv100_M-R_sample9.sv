module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] out_both_reg;
    reg [99:0] out_any_reg;
    reg [99:0] out_different_reg;

    integer i;
    always @* begin
        for (i = 0; i < 100; i++) begin
            if (i < 99) begin
                out_both_reg[i] = in[i] & in[i+1];
                out_any_reg[i] = in[i] | in[i-1];
            end else begin
                out_both_reg[i] = 1'b0;
                out_any_reg[i] = in[i] | in[0]; // Handling the edge case for out_any
            end
            if (i == 99) begin
                out_different_reg[i] = in[i] ^ in[0]; // Wrap-around case
            end else begin
                out_different_reg[i] = in[i] ^ in[i+1];
            end
        end
        out_both = out_both_reg;
        out_any = out_any_reg;
        out_different = out_different_reg;
    end

endmodule