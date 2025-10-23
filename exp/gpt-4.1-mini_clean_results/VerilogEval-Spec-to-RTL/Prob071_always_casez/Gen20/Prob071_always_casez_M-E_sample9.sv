module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

wire [7:0] mask;
wire [7:0] masked;

assign mask[0] = in[0];
assign mask[1] = ~in[0] & in[1];
assign mask[2] = ~in[1] & ~in[0] & in[2];
assign mask[3] = ~in[2] & ~in[1] & ~in[0] & in[3];
assign mask[4] = ~in[3] & ~in[2] & ~in[1] & ~in[0] & in[4];
assign mask[5] = ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0] & in[5];
assign mask[6] = ~in[5] & ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0] & in[6];
assign mask[7] = ~in[6] & ~in[5] & ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0] & in[7];

// This vector has only one bit set corresponding to the first set bit of 'in' or zero if none
assign masked = mask;

always @(*) begin
    casez(masked)
        8'b00000001: pos = 3'd0;
        8'b0000001?: pos = 3'd1;
        8'b000001??: pos = 3'd2;
        8'b00001???: pos = 3'd3;
        8'b0001????: pos = 3'd4;
        8'b001?????: pos = 3'd5;
        8'b01??????: pos = 3'd6;
        8'b1???????: pos = 3'd7;
        default:     pos = 3'd0; // no bits set
    endcase
end

endmodule