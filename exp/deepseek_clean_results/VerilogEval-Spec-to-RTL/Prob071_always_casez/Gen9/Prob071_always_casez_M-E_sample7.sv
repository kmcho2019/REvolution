module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

wire [7:0] mask;
wire [2:0] pos_comb [7:0];

// Generate mask to propagate '1's to more significant bits
assign mask[0] = in[0];
assign mask[1] = in[1] | mask[0];
assign mask[2] = in[2] | mask[1];
assign mask[3] = in[3] | mask[2];
assign mask[4] = in[4] | mask[3];
assign mask[5] = in[5] | mask[4];
assign mask[6] = in[6] | mask[5];
assign mask[7] = in[7] | mask[6];

// Generate position for each bit
assign pos_comb[0] = in[0] ? 3'd0 : 3'b000;
assign pos_comb[1] = (in[1] & ~mask[0]) ? 3'd1 : 3'b000;
assign pos_comb[2] = (in[2] & ~mask[1]) ? 3'd2 : 3'b000;
assign pos_comb[3] = (in[3] & ~mask[2]) ? 3'd3 : 3'b000;
assign pos_comb[4] = (in[4] & ~mask[3]) ? 3'd4 : 3'b000;
assign pos_comb[5] = (in[5] & ~mask[4]) ? 3'd5 : 3'b000;
assign pos_comb[6] = (in[6] & ~mask[5]) ? 3'd6 : 3'b000;
assign pos_comb[7] = (in[7] & ~mask[6]) ? 3'd7 : 3'b000;

// Combine all position results
always @(*) begin
    pos = pos_comb[0] | pos_comb[1] | pos_comb[2] | pos_comb[3] |
          pos_comb[4] | pos_comb[5] | pos_comb[6] | pos_comb[7];
end

endmodule