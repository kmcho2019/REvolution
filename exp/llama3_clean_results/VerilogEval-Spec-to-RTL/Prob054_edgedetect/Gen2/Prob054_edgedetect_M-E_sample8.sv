module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [1:0] sr [7:0];

always @(posedge clk) begin
    for (int i = 0; i < 8; i++) begin
        sr[i][0] <= in[i];
        sr[i][1] <= sr[i][0];
    end
end

assign pedge = {sr[7][0] & ~sr[7][1], sr[6][0] & ~sr[6][1], sr[5][0] & ~sr[5][1], sr[4][0] & ~sr[4][1], sr[3][0] & ~sr[3][1], sr[2][0] & ~sr[2][1], sr[1][0] & ~sr[1][1], sr[0][0] & ~sr[0][1]};

endmodule