module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter; // Counter to count the number of valid input data
reg [9:0] sum; // Register to store the accumulated sum
reg valid_out_reg; // Register to store the valid_out signal

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset
        counter <= 0;
        sum <= 0;
        valid_out_reg <= 0;
    end else if (valid_in) begin // When valid_in is 1
        if (counter < 4) begin // If less than 4 valid input data
            sum <= sum + data_in; // Accumulate the input data
            counter <= counter + 1; // Increment the counter
            valid_out_reg <= 0; // Set valid_out to 0
        end else begin // When 4 valid input data have been received
            sum <= sum + data_in; // Accumulate the last input data
            valid_out_reg <= 1; // Set valid_out to 1
            counter <= 0; // Reset the counter
        end
    end else begin // When valid_in is 0
        counter <= counter; // Keep the counter unchanged
        sum <= sum; // Keep the accumulated sum unchanged
        valid_out_reg <= 0; // Set valid_out to 0
    end
end

always @ (posedge clk) begin
    if (valid_out_reg) begin // When valid_out is 1
        data_out <= sum; // Output the accumulated sum
    end else begin // When valid_out is 0
        data_out <= 0; // Output 0
    end
end

assign valid_out = valid_out_reg && (counter == 4); // Set valid_out to 1 when 4 valid input data have been received and valid_out_reg is 1

endmodule