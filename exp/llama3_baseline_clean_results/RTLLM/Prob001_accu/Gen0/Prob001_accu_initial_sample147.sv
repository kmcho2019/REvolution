module accu (
    input               clk,
    input               rst_n,
    input               valid_in,
    input     [7:0]     data_in,
    output    [9:0]     data_out,
    output              valid_out
);

reg     [9:0]     data_out_reg;
reg               valid_out_reg;
reg     [1:0]     cnt_reg;
reg     [7:0]     data_reg [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out_reg <= 10'd0;
        valid_out_reg <= 1'b0;
        cnt_reg <= 2'd0;
        for (int i = 0; i < 4; i++) begin
            data_reg[i] <= 8'd0;
        end
    end else begin
        data_out_reg <= data_out_reg;
        valid_out_reg <= 1'b0;
        cnt_reg <= cnt_reg;
        if (valid_in) begin
            case (cnt_reg)
                2'd0: begin
                    data_reg[0] <= data_in;
                    cnt_reg <= cnt_reg + 1'b1;
                end
                2'd1: begin
                    data_reg[1] <= data_in;
                    cnt_reg <= cnt_reg + 1'b1;
                end
                2'd2: begin
                    data_reg[2] <= data_in;
                    cnt_reg <= cnt_reg + 1'b1;
                end
                2'd3: begin
                    data_reg[3] <= data_in;
                    cnt_reg <= 2'd0;
                    data_out_reg <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                    valid_out_reg <= 1'b1;
                end
                default: begin
                    cnt_reg <= cnt_reg;
                end
            endcase
        end else begin
            cnt_reg <= 2'd0;
        end
    end
end

assign data_out = data_out_reg;
assign valid_out = valid_out_reg;

endmodule