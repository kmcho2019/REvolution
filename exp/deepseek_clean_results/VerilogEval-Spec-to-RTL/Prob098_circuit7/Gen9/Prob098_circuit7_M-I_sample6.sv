module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    q <= a ? ~q : q;  // Toggle when a=1, hold when a=0
end

endmodule