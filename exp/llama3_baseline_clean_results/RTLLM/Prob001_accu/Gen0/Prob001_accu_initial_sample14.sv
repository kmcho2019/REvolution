module accu(
    input         clk,
    input         rst_n,
    input  [7:0]  data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [9:0] accu_sum;
reg [1:0]  counter;
reg [9:0]  temp_sum;
reg         valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accu_sum  <= 10'd0;
        counter   <= 2'd0;
        valid_out_reg <= 1'd0;
        temp_sum  <= 10'd0;
    end else begin
        if (valid_in) begin
            if (counter == 2'd3) begin
                accu_sum  <= temp_sum + data_in;
                valid_out_reg <= 1'd1;
                counter   <= 2'd0;
                temp_sum  <= 10'd0;
            end else begin
                temp_sum  <= temp_sum + data_in;
                counter   <= counter + 1'd1;
                valid_out_reg <= 1'd0;
            end
        end else begin
            valid_out_reg <= 1'd0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = accu_sum;

endmodule