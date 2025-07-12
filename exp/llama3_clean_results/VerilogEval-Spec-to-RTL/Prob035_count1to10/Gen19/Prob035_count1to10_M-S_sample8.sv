module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    count <= (reset || count == 10) ? 1 : (count == 9 ? 1 : count + 1);
end

assign q = count;

endmodule