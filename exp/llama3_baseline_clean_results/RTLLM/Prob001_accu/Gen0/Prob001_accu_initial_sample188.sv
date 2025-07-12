module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt;
reg [9:0] accu_sum;
reg valid_out_reg;

assign valid_out = valid_out_reg;
assign data_out = accu_sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        accu_sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            case (cnt)
                2'b00: begin
                    accu_sum <= {2'b0, data_in};
                    cnt <= cnt + 1'b1;
                    valid_out_reg <= 1'b0;
                end
                2'b01: begin
                    accu_sum <= accu_sum + {2'b0, data_in};
                    cnt <= cnt + 1'b1;
                    valid_out_reg <= 1'b0;
                end
                2'b10: begin
                    accu_sum <= accu_sum + {2'b0, data_in};
                    cnt <= cnt + 1'b1;
                    valid_out_reg <= 1'b0;
                end
                2'b11: begin
                    accu_sum <= accu_sum + {2'b0, data_in};
                    valid_out_reg <= 1'b1;
                end
            endcase
        end else begin
            cnt <= cnt;
            accu_sum <= accu_sum;
            valid_out_reg <= 1'b0;
        end
        // Reset counter and valid_out after output
        if (valid_out_reg) begin
            cnt <= 2'b00;
            accu_sum <= 10'b0;
            valid_out_reg <= 1'b0;
        end
    end
end

endmodule