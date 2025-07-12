module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    count <= (reset || count == 4'd9) ? 4'd0 : count + 1'b1;
end

assign q = count;

endmodule