module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        sum <= 0;
    end else if (valid_in) begin
        sum <= sum + data_in;
        cnt <= cnt + 1;
        if (cnt == 4 - 1) begin // since cnt starts from 0
            cnt <= 0;
        end
    end
end

assign valid_out = (cnt == 4 - 1); // since cnt starts from 0
assign data_out = sum;

endmodule