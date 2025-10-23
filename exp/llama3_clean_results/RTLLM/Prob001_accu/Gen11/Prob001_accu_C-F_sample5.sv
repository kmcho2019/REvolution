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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        sum <= 0;
    end else if (valid_in) begin
        case (cnt)
            0: begin
                sum <= {2'b0, data_in};
                cnt <= cnt + 1;
            end
            1: begin
                sum <= sum + {2'b0, data_in};
                cnt <= cnt + 1;
            end
            2: begin
                sum <= sum + {2'b0, data_in};
                cnt <= cnt + 1;
            end
            3: begin
                sum <= sum + {2'b0, data_in};
                cnt <= 0;
            end
            default: begin
                cnt <= 0;
                sum <= 0;
            end
        endcase
    end else begin
        cnt <= 0;
        sum <= 0;
    end
end

reg valid_out_reg;
always @(posedge clk) begin
    if (cnt == 0 && sum!= 0) begin
        valid_out_reg <= 1'b1;
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule