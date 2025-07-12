module TopModule #(
    parameter COUNT_START = 1,
    parameter COUNT_END = 10
)(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= COUNT_START;
    end else begin
        count <= next_count;
    end
end

assign next_count = (count == COUNT_END) ? COUNT_START : (count + 1);
assign q = count;

endmodule