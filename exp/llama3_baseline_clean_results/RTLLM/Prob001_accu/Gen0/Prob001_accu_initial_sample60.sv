module accu(
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg [1:0] cnt; // Counter for valid inputs
reg [9:0] sum; // Accumulator for input data
reg         valid_out_reg; // Register for valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        cnt <= 2'd0;
        sum <= 10'd0;
        valid_out_reg <= 1'd0;
    end else if (valid_in) begin // If valid input
        if (cnt == 2'd3) begin // If this is the fourth valid input
            sum <= sum + data_in; // Accumulate the current input
            valid_out_reg <= 1'd1; // Set valid_out to 1 for this cycle
            cnt <= 2'd0; // Reset counter
        end else begin
            if (cnt == 2'd0) begin // First valid input
                sum <= data_in; // Initialize sum with the first input
            end else begin
                sum <= sum + data_in; // Accumulate the current input
            end
            cnt <= cnt + 1'd1; // Increment counter
            valid_out_reg <= 1'd0; // valid_out is 0 for this cycle
        end
    end else begin // If not a valid input
        valid_out_reg <= 1'd0; // valid_out remains 0
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? sum : 10'd0;

endmodule