module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] fifo_stage1;
reg [7:0] fifo_stage2;
reg valid_stage1;
reg valid_stage2;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_stage1 <= 0;
        fifo_stage2 <= 0;
        valid_stage1 <= 0;
        valid_stage2 <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in) begin
            if (!valid_stage1) begin
                fifo_stage1 <= data_in;
                valid_stage1 <= 1;
            end else if (!valid_stage2) begin
                fifo_stage2 <= data_in;
                valid_stage2 <= 1;
                valid_out_reg <= 1;
            end
        end else begin
            valid_out_reg <= 0;
        end

        if (valid_out_reg) begin
            valid_stage1 <= 0;
            valid_stage2 <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = {fifo_stage1, fifo_stage2};

endmodule