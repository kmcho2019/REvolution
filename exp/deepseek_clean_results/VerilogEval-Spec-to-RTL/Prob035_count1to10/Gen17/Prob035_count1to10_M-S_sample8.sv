module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    q <= (reset || q == 4'b1010) ? 4'b0001 : q + 1;
end

endmodule