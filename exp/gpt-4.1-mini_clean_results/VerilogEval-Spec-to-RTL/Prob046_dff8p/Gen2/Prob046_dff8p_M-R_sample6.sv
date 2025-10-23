module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(negedge clk) begin
            if (reset)
                q_reg[i] <= 1'b0 | ((8'h34 >> i) & 1'b1);
            else
                q_reg[i] <= d[i];
        end
    end
endgenerate

assign q = q_reg;

endmodule