module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

localparam MAX_COUNT = 4'd9;  // Local parameter for maintainability

// Gray code encoding for the decade counter
// Sequence: 0000, 0001, 0011, 0010, 0110, 0111, 0101, 0100, 1100, 1101
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        case (q)
            4'b0000: q <= 4'b0001;
            4'b0001: q <= 4'b0011;
            4'b0011: q <= 4'b0010;
            4'b0010: q <= 4'b0110;
            4'b0110: q <= 4'b0111;
            4'b0111: q <= 4'b0101;
            4'b0101: q <= 4'b0100;
            4'b0100: q <= 4'b1100;
            4'b1100: q <= 4'b1101;
            4'b1101: q <= 4'b0000;
            default: q <= 4'b0000;
        endcase
    end
end

endmodule