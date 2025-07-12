module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        case (q)
            4'b0000: q <= 4'b0001;  // 0 → 1
            4'b0001: q <= 4'b0010;  // 1 → 2
            4'b0010: q <= 4'b0100;  // 2 → 4
            4'b0100: q <= 4'b1000;  // 4 → 8
            4'b1000: q <= 4'b0011;  // 8 → 3
            4'b0011: q <= 4'b0110;  // 3 → 6
            4'b0110: q <= 4'b1100;  // 6 → 12
            4'b1100: q <= 4'b0101;  // 12 → 5
            4'b0101: q <= 4'b1010;  // 5 → 10
            4'b1010: q <= 4'b0000;  // 10 → 0
            default: q <= 4'b0000;  // safety net
        endcase
    end
end

endmodule