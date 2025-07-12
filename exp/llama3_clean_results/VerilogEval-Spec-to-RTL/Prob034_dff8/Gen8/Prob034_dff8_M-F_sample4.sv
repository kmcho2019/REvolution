module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'b0
);

always @(posedge clk) begin
    // Assign each bit of d to q at the positive edge of clk
    q <= d;
end

endmodule