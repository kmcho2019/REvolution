module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt; // Counter to track the number of valid inputs
reg [9:0] sum; // Register to hold the accumulated sum
reg valid_out_reg; // Register to hold the valid_out signal

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in; // Accumulate the input data
            cnt <= cnt + 1'b1; // Increment the counter
        end
        if (cnt == 2'b11) begin // Check if four valid inputs are received
            valid_out_reg <= 1'b1; // Set valid_out to 1 for one cycle
        end else begin
            valid_out_reg <= 1'b0; // Otherwise, set valid_out to 0
        end
        if (cnt == 2'b11) begin // Reset the counter and sum after output
            cnt <= 2'b00;
            sum <= 10'b0;
        end
    end
end

assign valid_out = valid_out_reg; // Assign the valid_out signal
assign data_out = (cnt == 2'b11) ? sum : 10'b0; // Output the accumulated sum when valid_out is 1

endmodule