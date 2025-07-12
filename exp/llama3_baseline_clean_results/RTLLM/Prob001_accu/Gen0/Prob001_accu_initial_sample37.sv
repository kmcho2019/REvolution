module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt; // counter to track the number of valid inputs
reg [9:0] sum; // accumulator to store the sum of inputs
reg valid_out_reg; // register to store the valid_out signal

// reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end
    else begin
        // when valid_in is 1, add data_in to sum and increment counter
        if (valid_in) begin
            sum <= sum + data_in;
            cnt <= cnt + 1'b1;
        end
        
        // when counter reaches 4, output sum and set valid_out to 1
        if (cnt == 2'b11) begin
            valid_out_reg <= 1'b1;
            cnt <= 2'b00; // reset counter
        end
        else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (cnt == 2'b11) ? sum : 10'b0;

endmodule