module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        case (q)
            // Precomputed maximal-length sequence for 5-bit LFSR with taps at 5 and 3
            5'b00000: q <= 5'b00000; // Should never occur in maximal-length sequence
            5'b00001: q <= 5'b10000;
            5'b00010: q <= 5'b01000;
            5'b00011: q <= 5'b10100;
            5'b00100: q <= 5'b01010;
            5'b00101: q <= 5'b00101;
            5'b00110: q <= 5'b10010;
            5'b00111: q <= 5'b11001;
            5'b01000: q <= 5'b11100;
            5'b01001: q <= 5'b01110;
            5'b01010: q <= 5'b00111;
            5'b01011: q <= 5'b10001;
            5'b01100: q <= 5'b11000;
            5'b01101: q <= 5'b01100;
            5'b01110: q <= 5'b00110;
            5'b01111: q <= 5'b00011;
            5'b10000: q <= 5'b10010;
            5'b10001: q <= 5'b11001;
            5'b10010: q <= 5'b11100;
            5'b10011: q <= 5'b01110;
            5'b10100: q <= 5'b00111;
            5'b10101: q <= 5'b10001;
            5'b10110: q <= 5'b11000;
            5'b10111: q <= 5'b01100;
            5'b11000: q <= 5'b00110;
            5'b11001: q <= 5'b00011;
            5'b11010: q <= 5'b10001;
            5'b11011: q <= 5'b11000;
            5'b11100: q <= 5'b01100;
            5'b11101: q <= 5'b00110;
            5'b11110: q <= 5'b00011;
            5'b11111: q <= 5'b10001;
            default:  q <= 5'b00001; // Fallback to initial state
        endcase
    end
end

endmodule