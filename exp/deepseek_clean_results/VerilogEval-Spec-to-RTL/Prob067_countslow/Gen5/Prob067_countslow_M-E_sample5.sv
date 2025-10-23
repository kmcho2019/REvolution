module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [4:0] johnson_cnt;

always @(posedge clk) begin
    if (reset) begin
        johnson_cnt <= 5'b00001;
    end
    else if (slowena) begin
        johnson_cnt <= {johnson_cnt[3:0], ~johnson_cnt[4]};
    end
end

always @(*) begin
    case (johnson_cnt)
        5'b00001: q = 4'b0000;
        5'b00011: q = 4'b0001;
        5'b00111: q = 4'b0010;
        5'b01111: q = 4'b0011;
        5'b11111: q = 4'b0100;
        5'b11110: q = 4'b0101;
        5'b11100: q = 4'b0110;
        5'b11000: q = 4'b0111;
        5'b10000: q = 4'b1000;
        5'b00000: q = 4'b1001;
        default:  q = 4'b0000;
    endcase
end

endmodule