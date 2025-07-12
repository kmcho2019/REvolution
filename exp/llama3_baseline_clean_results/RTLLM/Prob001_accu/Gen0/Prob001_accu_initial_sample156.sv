module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] count;
reg [9:0] accu_sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 0;
        accu_sum <= 0;
        valid_out <= 0;
    end else if (valid_in) begin
        if (count == 4) begin
            valid_out <= 1;
            data_out <= accu_sum;
            count <= 0;
            accu_sum <= 0;
        end else begin
            accu_sum <= accu_sum + data_in;
            count <= count + 1;
            valid_out <= 0;
        end
    end else begin
        valid_out <= 0;
    end
end

endmodule