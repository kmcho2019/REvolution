module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

integer i;

always @(posedge clk) begin
    for (i = 0; i < 8; i = i + 1) begin
        q[i] <= d[i];
    end
end

endmodule