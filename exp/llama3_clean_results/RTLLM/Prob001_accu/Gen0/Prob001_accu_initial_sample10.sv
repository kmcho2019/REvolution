module accu(
    input               clk,
    input               rst_n,
    input      [7:0]    data_in,
    input               valid_in,
    output              valid_out,
    output     [9:0]    data_out
);

reg [1:0]  cnt;  // counter to track the number of valid inputs
reg [9:0]  sum;  // register to store the accumulated sum
reg         valid_out_reg;  // register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            if (cnt == 2'b11) begin
                // output the accumulated sum and reset the counter and sum
                sum <= sum + data_in;
                cnt <= 2'b00;
                valid_out_reg <= 1'b1;
            end else begin
                // accumulate the input data and increment the counter
                sum <= (cnt == 2'b00) ? data_in : sum + data_in;
                cnt <= cnt + 1'b1;
                valid_out_reg <= 1'b0;
            end
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = (cnt == 2'b11) ? valid_out_reg : 1'b0;
assign data_out = (cnt == 2'b11) ? sum : 10'b0;

endmodule