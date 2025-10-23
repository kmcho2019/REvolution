module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q[0] <= 1'b0;
        q[1] <= 1'b0;
        q[2] <= 1'b0;
        q[3] <= 1'b0;
        q[4] <= 1'b0;
        q[5] <= 1'b0;
        q[6] <= 1'b0;
        q[7] <= 1'b0;
    end
    else begin
        q[0] <= d[0];
        q[1] <= d[1];
        q[2] <= d[2];
        q[3] <= d[3];
        q[4] <= d[4];
        q[5] <= d[5];
        q[6] <= d[6];
        q[7] <= d[7];
    end
end

endmodule