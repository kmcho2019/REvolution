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
            4'b1000: q <= 4'b0001;  // 8 → 1
            4'b1001: q <= 4'b0000;  // 9 → 0
            default: q <= q + 1'b1; // covers 3,5,6,7
        endcase
    end
end

endmodule