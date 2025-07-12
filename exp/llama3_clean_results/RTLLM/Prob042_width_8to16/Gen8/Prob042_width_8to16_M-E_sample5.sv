module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [7:0] data_reg1;
reg [7:0] data_reg2;
reg [1:0] data_cnt;
reg data_available;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg1   <= 8'd0;
        data_reg2   <= 8'd0;
        data_cnt    <= 2'd0;
        data_available <= 1'b0;
        valid_out   <= 1'b0;
        data_out    <= 16'd0;
    end
    else begin
        if (valid_in) begin
            if (data_cnt == 2'd0) begin
                data_reg1   <= data_in;
                data_cnt    <= data_cnt + 1'd1;
            end
            else if (data_cnt == 2'd1) begin
                data_reg2   <= data_in;
                data_cnt    <= data_cnt + 1'd1;
                data_available <= 1'b1;
            end
        end

        if (data_available) begin
            data_out    <= {data_reg1, data_reg2};
            valid_out   <= 1'b1;
            data_available <= 1'b0;
            data_cnt    <= 2'd0;
        end
        else begin
            valid_out   <= 1'b0;
        end
    end
end

endmodule