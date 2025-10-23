module accu(
    input           clk,
    input           rst_n,
    input  [7:0]    data_in,
    input           valid_in,
    output          valid_out,
    output [9:0]    data_out
);

reg [9:0] data_out_reg;
reg        valid_out_reg;
reg [1:0]  counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        data_out_reg <= 10'b0;
    end else if (valid_in) begin
        if (counter == 2'b11) begin
            counter <= 2'b00;
            data_out_reg <= data_out_reg + data_in;
            valid_out_reg <= 1'b1;
        end else begin
            if (counter == 2'b00) begin
                data_out_reg <= data_in;
            end else begin
                data_out_reg <= data_out_reg + data_in;
            end
            counter <= counter + 1'b1;
            valid_out_reg <= 1'b0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule