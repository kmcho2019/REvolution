module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt; // Counter to track the number of valid inputs
reg [9:0] sum; // Register to store the accumulated sum
reg valid_out_reg; // Register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset
        cnt <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin // When valid_in is 1
        if (cnt == 2'b11) begin // If 4 inputs have been accumulated
            valid_out_reg <= 1'b1; // Set valid_out to 1
            cnt <= 2'b00; // Reset counter
            sum <= 10'b0; // Reset accumulated sum
        end else begin
            sum <= sum + data_in; // Accumulate input data
            cnt <= cnt + 1'b1; // Increment counter
            valid_out_reg <= 1'b0; // valid_out is 0 until 4 inputs are accumulated
        end
    end else begin
        valid_out_reg <= 1'b0; // valid_out is 0 when valid_in is 0
    end
end

assign valid_out = valid_out_reg; // Assign valid_out_reg to output port
assign data_out = (cnt == 2'b11)? sum : 10'b0; // Output accumulated sum when 4 inputs are accumulated

endmodule