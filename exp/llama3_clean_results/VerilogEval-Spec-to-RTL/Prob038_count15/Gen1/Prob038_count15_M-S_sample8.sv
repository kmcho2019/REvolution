module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (reset) q <= 0;
    else q <= (q == 4'd15)? 0 : q + 1;
end

endmodule