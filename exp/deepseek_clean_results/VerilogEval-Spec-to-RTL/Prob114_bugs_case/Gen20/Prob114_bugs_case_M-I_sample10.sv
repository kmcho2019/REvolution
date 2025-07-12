module TopModule (
    input [7:0] code,
    output reg [4:0] out_valid = 5'b0
);

always @(*) begin
    case (code)
        8'h45: out_valid = 5'b1_0000;  // 0
        8'h16: out_valid = 5'b1_0001;  // 1
        8'h1e: out_valid = 5'b1_0010;  // 2
        8'h26: out_valid = 5'b1_0011;  // 3
        8'h25: out_valid = 5'b1_0100;  // 4
        8'h2e: out_valid = 5'b1_0101;  // 5
        8'h36: out_valid = 5'b1_0110;  // 6
        8'h3d: out_valid = 5'b1_0111;  // 7
        8'h3e: out_valid = 5'b1_1000;  // 8
        8'h46: out_valid = 5'b1_1001;  // 9
        default: out_valid = 5'b0_0000;
    endcase
end

assign valid = out_valid[4];
assign out = out_valid[3:0];

endmodule