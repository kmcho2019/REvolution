module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

wire [7:0] priority_mask;
wire [2:0] pos_comb [7:0];

// Generate priority mask: each bit is 1 if it's the first '1' from LSB
assign priority_mask[0] = in[0];
assign priority_mask[1] = in[1] & ~in[0];
assign priority_mask[2] = in[2] & ~(|in[1:0]);
assign priority_mask[3] = in[3] & ~(|in[2:0]);
assign priority_mask[4] = in[4] & ~(|in[3:0]);
assign priority_mask[5] = in[5] & ~(|in[4:0]);
assign priority_mask[6] = in[6] & ~(|in[5:0]);
assign priority_mask[7] = in[7] & ~(|in[6:0]);

// Encode each possible position
assign pos_comb[0] = 3'b000;
assign pos_comb[1] = 3'b001;
assign pos_comb[2] = 3'b010;
assign pos_comb[3] = 3'b011;
assign pos_comb[4] = 3'b100;
assign pos_comb[5] = 3'b101;
assign pos_comb[6] = 3'b110;
assign pos_comb[7] = 3'b111;

// Select the correct position based on priority mask
always @(*) begin
    pos = 3'b000; // Default case when no bits are set
    for (integer i = 0; i < 8; i = i + 1) begin
        if (priority_mask[i]) begin
            pos = pos_comb[i];
        end
    end
end

endmodule