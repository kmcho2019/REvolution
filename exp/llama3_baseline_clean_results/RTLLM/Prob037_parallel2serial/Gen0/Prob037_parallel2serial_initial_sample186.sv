module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;
reg valid;

assign valid_out = valid;
assign dout = data[3];

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data <= 4'b0000;
        cnt <= 2'b00;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin
            data <= d;
            cnt <= 2'b00;
            valid <= 1'b1;
        end else begin
            valid <= 1'b0;
            cnt <= cnt + 1'b1;
            data <= {data[2:0], data[3]};
        end
    end
end

endmodule