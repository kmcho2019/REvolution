module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] stage1_data;
reg [9:0] stage2_data;
reg [9:0] stage3_data;
reg [9:0] stage4_data;
reg [1:0] cnt;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_data <= 0;
        stage2_data <= 0;
        stage3_data <= 0;
        stage4_data <= 0;
        cnt <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in) begin
            stage1_data <= data_in;
            stage2_data <= stage1_data + data_in;
            stage3_data <= stage2_data + data_in;
            stage4_data <= stage3_data + data_in;
            cnt <= cnt + 1;
        end else begin
            stage1_data <= 0;
            stage2_data <= 0;
            stage3_data <= 0;
            stage4_data <= 0;
            cnt <= 0;
        end

        if (cnt == 4) begin
            valid_out_reg <= 1;
            data_out <= stage4_data;
        end else begin
            valid_out_reg <= 0;
            data_out <= 0;
        end
    end
end

assign valid_out = valid_out_reg;

endmodule