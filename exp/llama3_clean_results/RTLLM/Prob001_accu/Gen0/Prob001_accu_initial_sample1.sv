module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] data_out_reg;
reg valid_out_reg;
reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 10'b0;
    end else if (valid_in) begin
        if (counter == 2'b11) begin
            valid_out_reg <= 1'b1;
            data_out_reg <= sum;
            counter <= 2'b00;
            sum <= 10'b0;
        end else begin
            valid_out_reg <= 1'b0;
            sum <= sum + data_in;
            counter <= counter + 1'b1;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule