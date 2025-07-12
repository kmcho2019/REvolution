module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

parameter WIDTH = 4;
parameter MAX_COUNT = 10;
parameter RESET_VALUE = 1;

reg [WIDTH-1:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= RESET_VALUE;
    end else if (count == MAX_COUNT) begin
        count <= RESET_VALUE;
    end else begin
        count <= count + 1'b1;
    end
end

assign q = count;

endmodule