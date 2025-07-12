module TopModule #(
    parameter COUNT_START = 1,
    parameter COUNT_END = 10
)(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset || count == COUNT_END) begin
        count <= COUNT_START;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule