module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    case ({a, q})
        4'b1_xxx: q <= 3'd4;          // When a=1, set to 4 (x means don't care)
        4'b0_110: q <= 3'd0;          // When a=0 and q=6, reset to 0
        default:  q <= a ? 3'd4 : q + 1'b1; // Otherwise increment if a=0
    endcase
end

endmodule