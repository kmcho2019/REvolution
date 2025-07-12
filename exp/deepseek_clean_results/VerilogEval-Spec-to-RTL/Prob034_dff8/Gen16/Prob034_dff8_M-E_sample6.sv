module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] state;

always @(posedge clk) begin
    state[0] <= state[7] ^ d[0];
    state[1] <= state[0] ^ d[1];
    state[2] <= state[1] ^ d[2];
    state[3] <= state[2] ^ d[3];
    state[4] <= state[3] ^ d[4];
    state[5] <= state[4] ^ d[5];
    state[6] <= state[5] ^ d[6];
    state[7] <= state[6] ^ d[7];
end

assign q = state;

endmodule