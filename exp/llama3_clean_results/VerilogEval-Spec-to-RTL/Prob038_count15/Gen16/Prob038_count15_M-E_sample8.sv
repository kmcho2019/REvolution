module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

always @(posedge clk) begin
    case ({reset, q})
        5'b1xxxx: q <= 4'b0; // Reset condition
        5'b01xxx: q <= 4'b0001;
        5'b010xx: q <= 4'b0010;
        5'b0101x: q <= 4'b0011;
        5'b01100: q <= 4'b0100;
        5'b01101: q <= 4'b0101;
        5'b01110: q <= 4'b0110;
        5'b01111: q <= 4'b0111;
        5'b10000: q <= 4'b1000;
        5'b10001: q <= 4'b1001;
        5'b10010: q <= 4'b1010;
        5'b10011: q <= 4'b1011;
        5'b10100: q <= 4'b1100;
        5'b10101: q <= 4'b1101;
        5'b10110: q <= 4'b1110;
        5'b10111: q <= 4'b1111;
        5'b11000: q <= 4'b0000;
        5'b11001: q <= 4'b0000;
        5'b11010: q <= 4'b0000;
        5'b11011: q <= 4'b0000;
        5'b11100: q <= 4'b0000;
        5'b11101: q <= 4'b0000;
        5'b11110: q <= 4'b0000;
        5'b11111: q <= 4'b0000;
        default: q <= q + 1;
    endcase
end

endmodule