module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output              valid_out,
    output      [9:0]   data_out
);

reg [9:0] accu_sum;
reg [1:0] counter;
reg       valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accu_sum <= 0;
        counter <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in) begin
            accu_sum <= accu_sum + data_in;
            counter <= counter + 1;
            if (counter == 4) begin
                valid_out_reg <= 1;
            end else begin
                valid_out_reg <= 0;
            end
        end else begin
            if (counter == 4) begin
                accu_sum <= 0;
                counter <= 0;
                valid_out_reg <= 0;
            end
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (counter == 4) ? accu_sum : 0;

endmodule