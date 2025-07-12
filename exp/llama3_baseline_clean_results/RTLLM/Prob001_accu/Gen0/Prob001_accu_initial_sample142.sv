module accu(
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg [9:0] accu_sum;
reg [1:0] counter;
reg [7:0] data_reg [3:0];
reg       valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_sum  <= 10'd0;
        counter  <= 2'd0;
        valid_out_reg <= 1'b0;
        data_out <= 10'd0;
    end else begin
        if (valid_in) begin
            if (counter < 2'd4) begin
                data_reg[counter] <= data_in;
                counter <= counter + 1;
            end
            if (counter == 2'd4) begin
                accu_sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out_reg <= 1'b1;
                data_out <= accu_sum;
                counter <= 2'd0;
            end
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;

endmodule