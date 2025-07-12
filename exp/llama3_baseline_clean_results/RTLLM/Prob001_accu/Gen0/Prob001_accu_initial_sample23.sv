module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter; // Counter for tracking number of valid inputs
reg [9:0] sum;    // Accumulator for summing valid inputs
reg valid_out_reg; // Register for valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        counter <= 0;
        sum <= 0;
        valid_out_reg <= 0;
    end else if (valid_in) begin // If input is valid
        if (counter == 4) begin // If 4 valid inputs have been received
            valid_out_reg <= 1; // Set valid_out to 1 for this cycle
            sum <= sum; // Hold sum for output
            counter <= 0; // Reset counter for next set of inputs
        end else begin
            sum <= sum + data_in; // Accumulate sum
            counter <= counter + 1; // Increment counter
            valid_out_reg <= 0; // Ensure valid_out is 0 until 4 inputs are received
        end
    end else begin // If input is not valid
        valid_out_reg <= 0; // Ensure valid_out is 0
        if (counter == 0) begin // If no valid inputs have been received
            sum <= 0; // Reset sum
        end
    end
end

assign valid_out = valid_out_reg; // Assign registered valid_out to output
assign data_out = sum; // Assign accumulated sum to output

endmodule