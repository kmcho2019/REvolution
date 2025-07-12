module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt_reg;
reg [9:0] sum_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_reg <= 0;
        sum_reg <= 0;
        valid_out_reg <= 0;
    end else begin
        valid_out_reg <= 0; // Reset valid_out by default
        if (valid_in) begin
            case (cnt_reg)
                2'd0: begin
                    sum_reg <= data_in;
                    cnt_reg <= cnt_reg + 1;
                end
                2'd1: begin
                    sum_reg <= sum_reg + data_in;
                    cnt_reg <= cnt_reg + 1;
                end
                2'd2: begin
                    sum_reg <= sum_reg + data_in;
                    cnt_reg <= cnt_reg + 1;
                end
                2'd3: begin
                    sum_reg <= sum_reg + data_in;
                    cnt_reg <= 0; // Reset counter
                    valid_out_reg <= 1; // Set valid_out for this cycle
                end
            endcase
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum_reg;

endmodule