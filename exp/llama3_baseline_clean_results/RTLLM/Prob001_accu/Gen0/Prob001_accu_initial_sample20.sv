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
reg [1:0] counter_reg;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out_reg <= 0;
        valid_out_reg <= 0;
        counter_reg <= 0;
        sum_reg <= 0;
    end else begin
        data_out_reg <= data_out_reg;
        valid_out_reg <= 0;
        counter_reg <= counter_reg;
        sum_reg <= sum_reg;
        
        if (valid_in) begin
            sum_reg <= sum_reg + data_in;
            counter_reg <= counter_reg + 1;
        end
        
        if (counter_reg == 4) begin
            data_out_reg <= sum_reg;
            valid_out_reg <= 1;
            counter_reg <= 0;
            sum_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule