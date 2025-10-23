module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] accu_sum;
reg [1:0] count;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_sum <= 10'd0;
        count <= 2'd0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            accu_sum <= accu_sum + data_in;
            count <= count + 1'b1;
        end

        if (count == 2'd3) begin
            data_out <= accu_sum;
            valid_out <= 1'b1;
            accu_sum <= 10'd0;
            count <= 2'd0;
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule