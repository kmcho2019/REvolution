module accu(
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg [9:0] data_out_reg;
reg [7:0] data_accu [3:0];
reg [1:0]  counter;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 10'd0;
    end else begin
        if (valid_in) begin
            if (counter < 2'd4) begin
                data_accu[counter] <= data_in;
                counter <= counter + 1'd1;
            end
            if (counter == 2'd4) begin
                data_out_reg <= data_accu[0] + data_accu[1] + data_accu[2] + data_accu[3];
                valid_out_reg <= 1'b1;
                counter <= 2'd0;
            end
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule