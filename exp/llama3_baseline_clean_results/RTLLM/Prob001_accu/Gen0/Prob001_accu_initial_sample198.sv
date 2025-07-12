module accu(
    input clk, 
    input rst_n, 
    input [7:0] data_in, 
    input valid_in, 
    output reg valid_out, 
    output reg [9:0] data_out
);

reg [1:0] counter; // Counter to track the number of valid inputs
reg [9:0] accumulator; // Register to store the accumulated sum

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        counter <= 2'b00; // Reset counter
        accumulator <= 10'b0; // Reset accumulator
        valid_out <= 1'b0; // Reset valid_out signal
        data_out <= 10'b0; // Reset data_out
    end else begin
        if (valid_in) begin // If input is valid
            if (counter == 2'b11) begin // If four valid inputs received
                data_out <= accumulator + data_in; // Output accumulated sum plus current input
                valid_out <= 1'b1; // Set valid_out signal to 1
                counter <= 2'b00; // Reset counter for next set of inputs
                accumulator <= 10'b0; // Reset accumulator for next set of inputs
            end else begin // If fewer than four valid inputs received
                accumulator <= accumulator + data_in; // Accumulate sum
                counter <= counter + 1'b1; // Increment counter
                valid_out <= 1'b0; // Keep valid_out signal at 0
            end
        end else begin // If input is not valid
            valid_out <= 1'b0; // Keep valid_out signal at 0
        end
    end
end

always @ (posedge clk) begin
    if (valid_out) begin
        valid_out <= 1'b0; // Reset valid_out signal after one cycle
    end
end

endmodule