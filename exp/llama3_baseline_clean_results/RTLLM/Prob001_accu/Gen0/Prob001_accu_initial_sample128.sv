module accu(
    input clk, 
    input rst_n, 
    input [7:0] data_in, 
    input valid_in, 
    output valid_out, 
    output [9:0] data_out
);

reg [9:0] sum;
reg [1:0] counter;
reg [9:0] data_out_reg;
reg valid_out_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 10'd0;
        counter <= 2'd0;
        data_out_reg <= 10'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        sum <= sum + data_in;
        counter <= counter + 1;
        if (counter == 4'd4) begin
            data_out_reg <= sum;
            valid_out_reg <= 1'b1;
            sum <= 10'd0;
            counter <= 2'd0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign data_out = data_out_reg;
assign valid_out = valid_out_reg;

endmodule