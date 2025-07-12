module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Gray code sequence for decade counter: 0-9
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Gray code for 0
    end else begin
        case (q)
            4'b0000: q <= 4'b0001;  // 0->1
            4'b0001: q <= 4'b0011;  // 1->2
            4'b0011: q <= 4'b0010;  // 2->3
            4'b0010: q <= 4'b0110;  // 3->4
            4'b0110: q <= 4'b0111;  // 4->5
            4'b0111: q <= 4'b0101;  // 5->6
            4'b0101: q <= 4'b0100;  // 6->7
            4'b0100: q <= 4'b1100;  // 7->8
            4'b1100: q <= 4'b1000;  // 8->9
            4'b1000: q <= 4'b0000;  // 9->0
            default: q <= 4'b0000;  // fault recovery
        endcase
    end
end

endmodule