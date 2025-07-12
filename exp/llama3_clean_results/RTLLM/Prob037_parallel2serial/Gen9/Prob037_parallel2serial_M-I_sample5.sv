module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] cnt;
reg [3:0] data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        data <= 4'b0;
    end else if (cnt == 3) begin
        cnt <= 0;
        data <= d;
    end else if (cnt != 0) begin
        cnt <= cnt + 1;
    end
end

assign valid_out = (cnt == 0) ? 1 : 0;
assign dout = data[3 - cnt];

endmodule