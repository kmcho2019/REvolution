module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] temp_q;

always @(posedge clk) begin
    temp_q <= {temp_q[6:0], d[7]};
    q <= {temp_q[6:0], d[7]};
end

initial begin
    q = 8'b0;
    temp_q = 8'b0;
end

endmodule