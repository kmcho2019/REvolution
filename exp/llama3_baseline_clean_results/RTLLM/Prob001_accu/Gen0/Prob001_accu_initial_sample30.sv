module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [1:0]  cnt;
reg [9:0]  accu_reg;
reg         valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt         <= 2'b00;
        accu_reg    <= 10'b0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        case (cnt)
            2'b00: begin
                accu_reg    <= {2'b0, data_in};
                cnt         <= cnt + 1'b1;
            end
            2'b01: begin
                accu_reg    <= accu_reg + {2'b0, data_in};
                cnt         <= cnt + 1'b1;
            end
            2'b10: begin
                accu_reg    <= accu_reg + {2'b0, data_in};
                cnt         <= cnt + 1'b1;
            end
            2'b11: begin
                accu_reg    <= accu_reg + {2'b0, data_in};
                cnt         <= 2'b00;
                valid_out_reg <= 1'b1;
            end
            default: begin
                cnt         <= cnt;
                accu_reg    <= accu_reg;
            end
        endcase
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out  = accu_reg;

endmodule