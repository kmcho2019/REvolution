module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt;
reg [9:0] sum;
reg [9:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        sum <= 0;
        data_out_reg <= 0;
    end else begin
        if (valid_in) begin
            sum <= (cnt == 0) ? data_in : sum + data_in;
            cnt <= (cnt == 3) ? 0 : cnt + 1;
            if (cnt == 0) begin
                data_out_reg <= sum;
            end
        end else begin
            cnt <= 0;
            sum <= 0;
        end
    end
end

assign valid_out = (cnt == 0) && (sum != 0);
assign data_out = data_out_reg;

endmodule