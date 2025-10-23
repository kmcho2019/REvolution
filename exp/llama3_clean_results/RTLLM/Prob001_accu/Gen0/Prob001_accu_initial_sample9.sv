module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter; // counter to track the number of valid inputs
reg [9:0] accumulated_sum; // register to store the accumulated sum

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        accumulated_sum <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else if (valid_in) begin
        // accumulate the input data
        if (counter < 4) begin
            accumulated_sum <= accumulated_sum + data_in;
            counter <= counter + 1;
            valid_out <= 0;
        end else begin
            // output the accumulated sum and reset the counter and sum
            data_out <= accumulated_sum + data_in;
            valid_out <= 1;
            counter <= 0;
            accumulated_sum <= 0;
        end
    end else begin
        valid_out <= 0;
    end
end

// reset valid_out after one cycle
always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 0;
    end
end

endmodule