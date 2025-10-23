module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

parameter MAX_COUNT = 4'd9;

always @ (posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (count == MAX_COUNT) begin
        count <= 4'b0000;
    end else begin
        count <= count + 1'b1;
    end
end

assign q = count;

endmodule