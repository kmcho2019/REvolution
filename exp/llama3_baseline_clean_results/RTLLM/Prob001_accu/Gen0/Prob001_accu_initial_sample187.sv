module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state;
reg [1:0] cnt;
reg [9:0] sum;
reg [9:0] data_out_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        cnt <= 0;
        sum <= 0;
        data_out_reg <= 0;
        valid_out_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (valid_in) begin
                    state <= 1;
                    cnt <= 1;
                    sum <= data_in;
                end else begin
                    state <= 0;
                end
            end
            1: begin // ACCUMULATE
                if (valid_in) begin
                    cnt <= cnt + 1;
                    sum <= sum + data_in;
                    if (cnt == 4) begin
                        state <= 0;
                        data_out_reg <= sum;
                        valid_out_reg <= 1;
                    end else begin
                        state <= 1;
                        valid_out_reg <= 0;
                    end
                end else begin
                    state <= 1;
                    valid_out_reg <= 0;
                end
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

always @(posedge clk) begin
    if (state == 0 && valid_out_reg == 1) begin
        valid_out_reg <= 0;
    end
end

endmodule