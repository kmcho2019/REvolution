module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Reset to 0
    end
    else if (slowena) begin
        case (q)
            4'b0000: q <= 4'b0001;  // 0 -> 1
            4'b0001: q <= 4'b0010;  // 1 -> 2
            4'b0010: q <= 4'b0011;  // 2 -> 3
            4'b0011: q <= 4'b0100;  // 3 -> 4
            4'b0100: q <= 4'b0101;  // 4 -> 5
            4'b0101: q <= 4'b0110;  // 5 -> 6
            4'b0110: q <= 4'b0111;  // 6 -> 7
            4'b0111: q <= 4'b1000;  // 7 -> 8
            4'b1000: q <= 4'b1001;  // 8 -> 9
            4'b1001: q <= 4'b0000;  // 9 -> 0
            default: q <= 4'b0000;   // Handle any unexpected states
        endcase
    end
end

endmodule