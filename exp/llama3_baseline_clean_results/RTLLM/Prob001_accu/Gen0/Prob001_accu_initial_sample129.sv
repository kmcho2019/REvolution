module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter; // counter to track the number of valid input data
reg [9:0] sum; // register to store the accumulated sum

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        counter <= 0;
        sum <= 0;
        valid_out <= 0;
    end else if (valid_in) begin
        if (counter == 4) begin // output accumulated sum and reset counter
            data_out <= sum;
            valid_out <= 1;
            sum <= 0;
            counter <= 0;
        end else begin
            sum <= sum + data_in; // accumulate sum
            counter <= counter + 1;
            valid_out <= 0; // valid_out should be 0 when not outputting
        end
    end else begin
        valid_out <= 0; // valid_out should be 0 when not outputting
    end
end

// valid_out should only be 1 for one cycle
always @ (posedge clk) begin
    if (valid_out) begin
        valid_out <= 0;
    end
end

endmodule