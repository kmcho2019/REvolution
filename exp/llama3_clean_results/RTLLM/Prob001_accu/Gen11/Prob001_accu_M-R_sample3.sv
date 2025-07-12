module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] sum;
reg [1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 0;
        cnt <= 0;
    end else if (valid_in) begin
        sum <= (cnt == 0) ? data_in : sum + data_in;
        cnt <= (cnt == 3) ? 0 : cnt + 1;
    end
end

assign valid_out = (cnt == 0) && (sum != 0);
assign data_out = sum;

endmodule