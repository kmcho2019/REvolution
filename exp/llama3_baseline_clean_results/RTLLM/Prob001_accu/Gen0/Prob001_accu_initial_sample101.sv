module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [1:0]  counter;
reg [9:0]  sum;
reg [7:0]  data_reg [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'd0;
        sum     <= 10'd0;
        valid_out <= 1'b0;
        data_out  <= 10'd0;
    end else if (valid_in) begin
        if (counter < 2'd3) begin
            data_reg[counter] <= data_in;
            counter <= counter + 1;
        end else if (counter == 2'd3) begin
            sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_in;
            valid_out <= 1'b1;
            data_out  <= sum;
            counter <= 2'd0;
        end
    end else begin
        valid_out <= 1'b0;
    end
end

// To ensure valid_out is only 1 for one cycle
always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 1'b0;
    end
end

endmodule