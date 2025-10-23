module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

parameter MAX_COUNT = 9;
parameter BIT_WIDTH = 4;

reg [BIT_WIDTH-1:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (count == MAX_COUNT) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule