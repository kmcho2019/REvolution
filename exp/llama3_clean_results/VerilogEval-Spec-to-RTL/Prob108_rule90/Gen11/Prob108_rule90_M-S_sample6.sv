module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, right;
        if (i == 0) begin
            assign left = 1'b0;
            assign right = (i == 511) ? 1'b0 : q_reg[i + 1];
        end else if (i == 511) begin
            assign left = q_reg[i - 1];
            assign right = 1'b0;
        end else begin
            assign left = q_reg[i - 1];
            assign right = q_reg[i + 1];
        end
        assign q[i] = load ? data[i] : left ^ right;
    end
endgenerate

endmodule