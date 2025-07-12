module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter; // counter to count the number of valid input data
reg [9:0] sum; // register to accumulate the sum of input data

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset when rst_n is 0
        counter <= 2'd0;
        sum <= 10'd0;
        valid_out <= 1'b0;
        data_out <= 10'd0;
    end else if (valid_in) begin // when valid_in is 1
        if (counter == 4'd3) begin // if counter is 3, it means we have received 4 valid data
            data_out <= sum; // output the accumulated sum
            valid_out <= 1'b1; // set valid_out to 1
            counter <= 2'd0; // reset the counter
            sum <= 10'd0; // reset the accumulated sum
        end else begin
            sum <= sum + data_in; // accumulate the sum of input data
            counter <= counter + 1'd1; // increment the counter
            valid_out <= 1'b0; // set valid_out to 0
        end
    end else begin
        valid_out <= 1'b0; // set valid_out to 0 when valid_in is 0
    end
end

always @ (posedge clk) begin
    if (valid_out) begin // when valid_out is 1, reset it after one cycle
        valid_out <= 1'b0;
    end
end

endmodule