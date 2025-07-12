module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter; // Counter to keep track of the number of valid inputs
reg [9:0] accumulated_sum; // Accumulated sum of the input data

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset the module when rst_n is low
        counter <= 2'b00;
        accumulated_sum <= 10'b0000000000;
        valid_out <= 1'b0;
        data_out <= 10'b0000000000;
    end else if (valid_in) begin // If valid_in is 1, accumulate the input data
        if (counter == 4'b11) begin // If we have received 4 valid inputs, output the accumulated sum
            data_out <= accumulated_sum;
            valid_out <= 1'b1;
            counter <= 2'b00; // Reset the counter
            accumulated_sum <= 10'b0000000000; // Reset the accumulated sum
        end else begin
            counter <= counter + 1; // Increment the counter
            accumulated_sum <= accumulated_sum + data_in; // Accumulate the input data
            valid_out <= 1'b0; // valid_out is 0 until we have received 4 valid inputs
        end
    end else begin // If valid_in is 0, do nothing
        valid_out <= 1'b0;
    end
end

always @ (posedge clk) begin
    if (valid_out) begin // valid_out is 1 for only one cycle
        valid_out <= 1'b0;
    end
end

endmodule