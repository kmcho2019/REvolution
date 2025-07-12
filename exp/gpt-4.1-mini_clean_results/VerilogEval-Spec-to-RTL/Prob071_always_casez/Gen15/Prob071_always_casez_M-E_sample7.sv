module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

// One-hot vector with only the least significant set bit
wire [7:0] one_hot_lsb;
assign one_hot_lsb = in & (~in + 8'b1);

always @(*) begin
    case (one_hot_lsb)
        8'b0000_0001: pos = 3'd0;
        8'b0000_0010: pos = 3'd1;
        8'b0000_0100: pos = 3'd2;
        8'b0000_1000: pos = 3'd3;
        8'b0001_0000: pos = 3'd4;
        8'b0010_0000: pos = 3'd5;
        8'b0100_0000: pos = 3'd6;
        8'b1000_0000: pos = 3'd7;
        default:      pos = 3'd0;  // No bits set
    endcase
end

endmodule