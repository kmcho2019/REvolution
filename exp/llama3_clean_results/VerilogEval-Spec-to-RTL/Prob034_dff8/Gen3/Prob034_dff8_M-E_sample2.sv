module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

integer i;

always @(posedge clk) begin
    q[7:0] = {d[7], d[6:0]};
    for (i = 1; i <= 7; i++) begin
        q[i] = q[i-1];
    end
end

endmodule