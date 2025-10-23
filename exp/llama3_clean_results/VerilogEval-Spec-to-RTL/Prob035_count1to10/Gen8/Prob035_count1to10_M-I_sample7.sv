module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'd1;

always @(posedge clk) begin
    if (reset) count <= 4'd1;
    else if (count == 4'd10) count <= 4'd1;
    else count <= count + 1;
end

assign q = count;

endmodule