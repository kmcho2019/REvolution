module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Initialize to 1
    end
    else begin
        case (q)
            4'b1010: q <= 4'b0001;  // Special case: 10 → 1
            4'b0101: q <= {q[2:0], 1'b1};  // Special feedback for 5→6
            4'b1001: q <= {q[2:0], 1'b0};  // Special feedback for 9→10
            default: q <= {q[2:0], q[3] ^ q[2]};  // Standard LFSR feedback
        endcase
    end
end

endmodule