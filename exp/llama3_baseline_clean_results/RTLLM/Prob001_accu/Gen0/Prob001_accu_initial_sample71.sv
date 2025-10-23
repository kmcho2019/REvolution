module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0]   accu_reg;  // register to store the accumulated sum
reg [1:0]   count_reg; // counter to track the number of valid data received
reg         valid_out_reg; // register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_reg  <= 10'd0;
        count_reg <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (count_reg < 2'd3) begin
            accu_reg  <= accu_reg + data_in;
            count_reg <= count_reg + 1'd1;
        end else begin
            accu_reg  <= data_in;
            count_reg <= 1'd1;
        end
        if (count_reg == 2'd3) begin
            valid_out_reg <= 1'b1;
        end else begin
            valid_out_reg <= 1'b0;
        end
    end else begin
        count_reg <= count_reg;
        accu_reg  <= accu_reg;
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = accu_reg;

endmodule