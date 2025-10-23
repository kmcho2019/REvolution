module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter; // Counter to track the number of valid input data
reg [9:0] accu_sum; // Register to accumulate the sum of the input data
reg valid_out_r; // Register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset when rst_n is 0
        counter <= 2'b00;
        accu_sum <= 10'b0000000000;
        valid_out_r <= 1'b0;
    end else begin
        if (valid_in) begin // When valid_in is 1
            if (counter == 2'b11) begin // When counter reaches 4
                valid_out_r <= 1'b1; // Set valid_out to 1
                counter <= 2'b00; // Reset counter
                accu_sum <= 10'b0000000000; // Reset accumulated sum
            end else begin
                counter <= counter + 1'b1; // Increment counter
                accu_sum <= accu_sum + data_in; // Accumulate sum
                valid_out_r <= 1'b0; // Set valid_out to 0
            end
        end else begin
            valid_out_r <= 1'b0; // Set valid_out to 0 when valid_in is 0
        end
    end
end

assign valid_out = valid_out_r; // Assign valid_out signal
assign data_out = (valid_out_r) ? accu_sum : 10'b0000000000; // Assign data_out signal

endmodule