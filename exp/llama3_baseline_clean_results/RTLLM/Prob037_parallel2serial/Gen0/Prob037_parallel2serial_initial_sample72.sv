module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

reg [3:0] data;
reg [1:0] cnt;
reg        valid;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt   <= 2'd0;
        valid <= 1'b0;
    end else if (cnt == 2'd3) begin
        cnt   <= 2'd0;
        valid <= 1'b1;
        data  <= d;
    end else begin
        cnt   <= cnt + 1'b1;
        valid <= 1'b0;
        data  <= {data[2:0], data[3]};
    end
end

assign dout      = data[3];
assign valid_out = (cnt == 2'd0) && valid;

endmodule