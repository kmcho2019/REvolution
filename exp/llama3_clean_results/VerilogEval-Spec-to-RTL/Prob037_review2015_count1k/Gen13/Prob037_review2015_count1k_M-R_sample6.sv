module TopModule(
    input  clk,
    input  reset,
    output [9:0] q
);

parameter WIDTH = 10;
parameter MAX_VALUE = 10'd999;

reg [WIDTH-1:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 'd0;
    end else if (count == MAX_VALUE) begin
        count <= 'd0;
    end else begin
        count <= count + 1'd1;
    end
end

assign q = count;

endmodule