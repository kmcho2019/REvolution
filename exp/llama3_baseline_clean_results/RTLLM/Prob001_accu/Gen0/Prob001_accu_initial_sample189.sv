module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt; // Counter to track the number of valid input data
reg [9:0] sum; // Register to store the accumulated sum
reg valid_out_reg; // Register to store the valid_out signal

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, accumulated sum, and valid_out signal
        cnt <= 0;
        sum <= 0;
        valid_out_reg <= 0;
    end else if (valid_in) begin
        // If valid input data, increment the counter and update the accumulated sum
        cnt <= cnt + 1;
        sum <= sum + data_in;
        
        // If 4 valid input data received, output the accumulated sum and set valid_out to 1
        if (cnt == 4) begin
            valid_out_reg <= 1;
            cnt <= 0; // Reset the counter for next accumulation
        end else begin
            valid_out_reg <= 0;
        end
    end else begin
        // If not valid input data, reset the valid_out signal
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule