module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        sum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        if (valid_in) begin
            sum <= (counter == 2'b11)? data_in : sum + data_in;
            counter <= (counter == 2'b11)? 2'b00 : counter + 1'b1;
        end
        valid_out <= (counter == 2'b11)? 1'b1 : 1'b0;
        data_out <= (counter == 2'b11)? sum : 10'b0;
    end
end

endmodule