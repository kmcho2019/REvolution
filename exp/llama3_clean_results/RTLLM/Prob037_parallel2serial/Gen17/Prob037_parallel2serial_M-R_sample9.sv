module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

parameter DATA_WIDTH = 4;

reg [1:0] cnt;
reg [DATA_WIDTH-1:0] data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        data <= 0;
    end else begin
        if (cnt == DATA_WIDTH - 1) begin
            cnt <= 0;
            data <= d;
        end else begin
            cnt <= cnt + 1;
            data <= {data[DATA_WIDTH-2:0], 1'b0};
        end
    end
end

assign valid_out = (cnt == 0) ? 1 : 0;
assign dout = data[DATA_WIDTH-1];

endmodule