module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [1:0]  cnt;  // counter to track the number of valid input data
reg [9:0]  sum;  // register to store the accumulated sum
reg         valid_out_r;  // register to store the valid output signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // reset logic
        cnt <= 2'b00;
        sum <= 10'b0;
        valid_out_r <= 1'b0;
    end else begin
        if (valid_in) begin  // accumulate input data when valid_in is 1
            sum <= sum + data_in;
            cnt <= cnt + 1'b1;
        end
        if (cnt == 2'b11) begin  // output accumulated sum when 4 data are received
            valid_out_r <= 1'b1;
        end else begin
            valid_out_r <= 1'b0;
        end
        if (cnt == 2'b11) begin  // reset counter and sum after output
            cnt <= 2'b00;
            sum <= 10'b0;
        end
    end
end

assign valid_out = valid_out_r;

assign data_out = sum;

endmodule