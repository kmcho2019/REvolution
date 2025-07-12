module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] temp;

always @(posedge clk) begin
    q <= temp;
    temp <= {temp[6:0], d[7]};
end

always @(posedge clk) begin
    d <= {d[6:0], d[7]};
end

initial begin
    temp = 8'b0;
    q = 8'b0;
end

endmodule