module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;

wire [1:0] next_cnt;
assign next_cnt = (cnt == 3) ? 0 : cnt + 1;

wire [3:0] next_data;
assign next_data = (cnt == 3) ? d : {data[2:0], data[3]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        data <= 0;
    end else begin
        cnt <= next_cnt;
        data <= next_data;
    end
end

assign valid_out = (cnt == 0) ? 1 : 0;
assign dout = data[3];

endmodule