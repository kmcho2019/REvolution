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
reg [9:0] next_sum;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        sum <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in) begin
            case (cnt)
                0: begin
                    sum <= data_in;
                    cnt <= 1;
                end
                1: begin
                    sum <= sum + data_in;
                    cnt <= 2;
                end
                2: begin
                    sum <= sum + data_in;
                    cnt <= 3;
                end
                3: begin
                    sum <= sum + data_in;
                    cnt <= 0;
                    valid_out_reg <= 1;
                end
                default: begin
                    sum <= 0;
                    cnt <= 0;
                end
            endcase
        end else begin
            cnt <= 0;
            sum <= 0;
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule