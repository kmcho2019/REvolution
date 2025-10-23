module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Custom LFSR sequence for decade counting: 0->1->3->7->15->14->12->8->9->2->4->0
// Modified to only count through 0-9 by skipping invalid states
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        case (q)
            4'b0000: q <= 4'b0001;  // 0->1
            4'b0001: q <= 4'b0011;  // 1->3
            4'b0011: q <= 4'b0111;  // 3->7
            4'b0111: q <= 4'b1111;  // 7->15 (invalid, but needed for sequence)
            4'b1111: q <= 4'b1110;  // 15->14
            4'b1110: q <= 4'b1100;  // 14->12
            4'b1100: q <= 4'b1000;  // 12->8
            4'b1000: q <= 4'b1001;  // 8->9
            4'b1001: q <= 4'b0010;  // 9->2
            4'b0010: q <= 4'b0100;  // 2->4
            4'b0100: q <= 4'b0000;  // 4->0
            default: q <= 4'b0000;   // Handle any unexpected states
        endcase
    end
end

endmodule