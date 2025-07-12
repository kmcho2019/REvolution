module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] cnt;
reg [9:0] sum;
reg output_valid;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'd0;
        sum <= 10'd0;
        output_valid <= 1'd0;
        valid_out <= 1'd0;
    end else begin
        if (valid_in) begin
            if (cnt < 2'd3) begin
                sum <= sum + data_in;
                cnt <= cnt + 1'd1;
            end else begin
                sum <= sum + data_in;
                cnt <= 2'd0;
                output_valid <= 1'd1;
            end
        end else begin
            cnt <= 2'd0;
            sum <= 10'd0;
            output_valid <= 1'd0;
        end

        if (output_valid) begin
            valid_out <= 1'd1;
            data_out <= sum;
            output_valid <= 1'd0;
        end else begin
            valid_out <= 1'd0;
        end
    end
end

endmodule