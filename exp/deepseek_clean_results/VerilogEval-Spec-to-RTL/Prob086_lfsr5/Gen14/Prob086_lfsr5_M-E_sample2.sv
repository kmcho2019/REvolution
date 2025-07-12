module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    case ({reset, q})
        // Reset condition (has priority)
        6'b1_xxxxx: q <= 5'b00001;
        
        // Normal operation cases (all 31 possible states)
        6'b0_00001: q <= 5'b10000;
        6'b0_00010: q <= 5'b01000;
        6'b0_00011: q <= 5'b11000;
        6'b0_00100: q <= 5'b00100;
        6'b0_00101: q <= 5'b10100;
        6'b0_00110: q <= 5'b01100;
        6'b0_00111: q <= 5'b11100;
        6'b0_01000: q <= 5'b00010;
        6'b0_01001: q <= 5'b10010;
        6'b0_01010: q <= 5'b01010;
        6'b0_01011: q <= 5'b11010;
        6'b0_01100: q <= 5'b00110;
        6'b0_01101: q <= 5'b10110;
        6'b0_01110: q <= 5'b01110;
        6'b0_01111: q <= 5'b11110;
        6'b0_10000: q <= 5'b10001;
        6'b0_10001: q <= 5'b10001;
        6'b0_10010: q <= 5'b01001;
        6'b0_10011: q <= 5'b11001;
        6'b0_10100: q <= 5'b00101;
        6'b0_10101: q <= 5'b10101;
        6'b0_10110: q <= 5'b01101;
        6'b0_10111: q <= 5'b11101;
        6'b0_11000: q <= 5'b00011;
        6'b0_11001: q <= 5'b10011;
        6'b0_11010: q <= 5'b01011;
        6'b0_11011: q <= 5'b11011;
        6'b0_11100: q <= 5'b00111;
        6'b0_11101: q <= 5'b10111;
        6'b0_11110: q <= 5'b01111;
        6'b0_11111: q <= 5'b11111;
        
        // Default case (should never occur)
        default: q <= 5'b00001;
    endcase
end

endmodule