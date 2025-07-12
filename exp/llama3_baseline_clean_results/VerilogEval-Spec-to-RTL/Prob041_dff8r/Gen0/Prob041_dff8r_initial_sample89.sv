module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 8'd0;  // synchronous reset to zero
    end else begin
        q <= d;  // on positive edge of clk, set output to input d
    end
end

endmodule