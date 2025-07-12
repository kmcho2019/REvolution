module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q[0] <= d[0];
end

always @(posedge clk) begin
    q[1] <= d[1];
end

always @(posedge clk) begin
    q[2] <= d[2];
end

always @(posedge clk) begin
    q[3] <= d[3];
end

always @(posedge clk) begin
    q[4] <= d[4];
end

always @(posedge clk) begin
    q[5] <= d[5];
end

always @(posedge clk) begin
    q[6] <= d[6];
end

always @(posedge clk) begin
    q[7] <= d[7];
end

endmodule