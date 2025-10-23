module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (cnt == 3) begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

assign valid_out = (cnt == 0) ? 1 : 0;
assign dout = d[3 - cnt];

endmodule