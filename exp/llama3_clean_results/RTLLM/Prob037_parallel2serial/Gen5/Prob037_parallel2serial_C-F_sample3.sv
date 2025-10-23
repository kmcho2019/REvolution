module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        data <= 0;
        valid <= 0;
    end else begin
        if (cnt == 3) begin
            data <= d;
            cnt <= 0;
            valid <= 1;
        end else if (valid == 0) begin
            cnt <= cnt + 1;
            valid <= 0;
        end else begin
            cnt <= cnt + 1;
            data <= {data[2:0], 1'b0};
            if (cnt == 3) begin
                valid <= 0;
            end
        end
    end
end

assign valid_out = valid;
assign dout = data[3];

endmodule