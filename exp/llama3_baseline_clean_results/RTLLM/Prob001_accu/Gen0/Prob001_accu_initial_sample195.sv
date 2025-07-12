module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] accu_reg; // accumulator register
reg [1:0] count_reg; // counter register
reg valid_out_reg; // valid output register

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accu_reg <= 10'd0;
        count_reg <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            if (count_reg == 2'd3) begin
                // output accumulation result and reset counter
                accu_reg <= accu_reg + data_in;
                count_reg <= 2'd0;
                valid_out_reg <= 1'b1;
            end else begin
                // accumulate input data and increment counter
                accu_reg <= accu_reg + data_in;
                count_reg <= count_reg + 1'b1;
                valid_out_reg <= 1'b0;
            end
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (count_reg == 2'd3) ? accu_reg : 10'd0;

endmodule