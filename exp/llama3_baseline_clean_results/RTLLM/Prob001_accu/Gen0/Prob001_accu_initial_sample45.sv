module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter; // counter to keep track of the number of valid input data
reg [9:0] sum; // 10-bit register to store the accumulated sum

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'd0;
        sum <= 10'd0;
        valid_out <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'd3) begin
            // output the accumulated sum and set valid_out to 1
            data_out <= sum + data_in;
            valid_out <= 1'b1;
            counter <= 2'd0;
            sum <= 10'd0;
        end else begin
            // accumulate the input data
            sum <= sum + data_in;
            counter <= counter + 1'b1;
            valid_out <= 1'b0;
        end
    end else begin
        valid_out <= 1'b0;
    end
end

// reset valid_out after one cycle
always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 1'b0;
    end
end

endmodule