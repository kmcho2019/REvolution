module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001; // Reset to 1
    end else begin
        case (q)
            4'b0001: q <= 4'b0010; // 1 -> 2
            4'b0010: q <= 4'b0011; // 2 -> 3
            4'b0011: q <= 4'b0100; // 3 -> 4
            4'b0100: q <= 4'b0101; // 4 -> 5
            4'b0101: q <= 4'b0110; // 5 -> 6
            4'b0110: q <= 4'b0111; // 6 -> 7
            4'b0111: q <= 4'b1000; // 7 -> 8
            4'b1000: q <= 4'b1001; // 8 -> 9
            4'b1001: q <= 4'b1010; // 9 -> 10
            4'b1010: q <= 4'b0001; // 10 -> 1 (wrap around)
            default: q <= 4'b0001; // Handle unexpected states
        endcase
    end
end

endmodule