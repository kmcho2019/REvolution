module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

parameter MAX_COUNT = 10;

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 1;
    end else begin
        count <= (count == MAX_COUNT) ? 1 : count + 1;
    end
end

assign q = count;

endmodule