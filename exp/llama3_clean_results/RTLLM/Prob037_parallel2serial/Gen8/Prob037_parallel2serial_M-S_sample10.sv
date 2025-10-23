module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0;
        cnt <= 2'b0;
    end else begin
        if (cnt == 2'b11) begin
            data <= d;
            cnt <= 2'b00;
        end else begin
            cnt <= cnt + 1'b1;
            data <= {data[2:0], data[3]}; // Shift data to the right and keep MSB
        end
    end
end

assign valid_out = (cnt == 2'b00);
assign dout = data[3];

endmodule