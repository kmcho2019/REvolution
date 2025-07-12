module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

localparam RESET_VAL = 8'h34;
reg [7:0] q_reg;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(negedge clk) begin
            q_reg[i] <= reset ? RESET_VAL[i] : d[i];
        end
    end
endgenerate

assign q = q_reg;

endmodule