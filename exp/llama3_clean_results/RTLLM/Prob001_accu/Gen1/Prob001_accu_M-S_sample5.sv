module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        sum <= 10'b0;
    end else if (valid_in) begin
        sum <= (counter == 2'b11)? 10'b0 : sum + data_in;
        counter <= (counter == 2'b11)? 2'b00 : counter + 1'b1;
    end
end

assign valid_out = (counter == 2'b11) && valid_in;
assign data_out = (valid_out)? sum : 10'b0;

endmodule