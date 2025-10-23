module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        case (q)
            4'b0000: q <= 4'b0001;  // 0 → 1
            4'b0001: q <= 4'b0011;  // 1 → 3
            4'b0011: q <= 4'b0111;  // 3 → 7
            4'b0111: q <= 4'b0110;  // 7 → 6 (modified from 15 to stay in range)
            4'b0110: q <= 4'b1100;  // 6 → 12
            4'b1100: q <= 4'b1000;  // 12 → 8
            4'b1000: q <= 4'b0000;  // 8 → 0
            4'b1001: q <= 4'b0001;  // 9 → 1 (handle case if somehow we get to 9)
            default: q <= q + 1;    // catch-all for other states (shouldn't occur)
        endcase
    end
end

endmodule