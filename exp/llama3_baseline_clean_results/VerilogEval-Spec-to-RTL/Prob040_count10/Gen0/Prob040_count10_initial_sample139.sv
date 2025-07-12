module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 4'b0000;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (count == 4'b1001) begin // 10 in binary
        count <= 4'b0000;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule