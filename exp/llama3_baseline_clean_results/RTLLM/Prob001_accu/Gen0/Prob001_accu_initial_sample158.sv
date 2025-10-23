module accu (
    input               clk,
    input               rst_n,
    input      [7:0]    data_in,
    input               valid_in,
    output              valid_out,
    output     [9:0]    data_out
);

reg [9:0] accumulator; // register to store the accumulated sum
reg [1:0] count;       // register to store the count of valid data received
reg               valid_out_reg; // register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // asynchronous reset
        accumulator <= 10'd0;
        count <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin // on valid input
        if (count < 2'd3) begin // if count is less than 4
            accumulator <= accumulator + data_in; // accumulate the input data
            count <= count + 1'd1; // increment the count
            valid_out_reg <= 1'b0; // valid_out is 0
        end else begin // if count is 4
            accumulator <= accumulator + data_in; // accumulate the last input data
            valid_out_reg <= 1'b1; // set valid_out to 1
            count <= 2'd0; // reset the count
        end
    end else begin // on invalid input
        valid_out_reg <= 1'b0; // valid_out is 0
    end
end

assign data_out = accumulator; // assign the accumulated sum to the output
assign valid_out = (count == 2'd3 && valid_in) ? 1'b1 : valid_out_reg; // assign the valid_out signal

endmodule