module accu(
    input           clk,
    input           rst_n,
    input   [7:0]    data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]    data_out
);

reg [1:0]           cnt;
reg [9:0]           sum;
reg                 valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt         <= 2'd0;
        sum         <= 10'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            case (cnt)
                2'd0: begin
                    sum         <= data_in;
                    cnt         <= cnt + 1'd1;
                end
                2'd1: begin
                    sum         <= sum + data_in;
                    cnt         <= cnt + 1'd1;
                end
                2'd2: begin
                    sum         <= sum + data_in;
                    cnt         <= cnt + 1'd1;
                end
                2'd3: begin
                    sum         <= sum + data_in;
                    cnt         <= 2'd0;
                    valid_out_reg <= 1'b1;
                end
            endcase
        end else begin
            cnt         <= cnt;
            sum         <= sum;
            valid_out_reg <= 1'b0;
        end
    end
end

assign data_out  = sum;
assign valid_out = valid_out_reg;

endmodule