module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'd1;
reg [3:0] next_count;

always @(*) begin
    if (reset || count == 4'd10) next_count = 4'd1;
    else next_count = count + 1;
end

always @(posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule