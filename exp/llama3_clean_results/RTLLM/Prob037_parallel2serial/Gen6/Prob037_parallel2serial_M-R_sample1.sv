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
        cnt <= 2'b00;
        data <= 4'b0;
    end else begin
        if (cnt == 2'b11) begin 
            data <= d;
            cnt <= 2'b00;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

assign valid_out = (cnt == 2'b00);
assign dout = data[3 - cnt];

endmodule