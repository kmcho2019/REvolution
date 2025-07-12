module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;
reg clk_enable;

// Clock gating
assign clk_enable = enable ? clk : 1'b0;

always @(posedge clk_enable) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

assign Z = Q[{A, B, C}];

endmodule