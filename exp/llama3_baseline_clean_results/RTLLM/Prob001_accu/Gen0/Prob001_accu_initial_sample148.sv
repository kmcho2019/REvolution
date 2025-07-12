module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg [9:0] data_out_reg;
reg       valid_out_reg;
reg [1:0] counter_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out_reg <= 10'd0;
        valid_out_reg <= 1'b0;
        counter_reg <= 2'd0;
    end else begin
        valid_out_reg <= 1'b0;
        if (valid_in) begin
            case (counter_reg)
                2'd0: begin
                    data_out_reg <= data_in;
                    counter_reg <= counter_reg + 1;
                end
                2'd1: begin
                    data_out_reg <= data_out_reg + data_in;
                    counter_reg <= counter_reg + 1;
                end
                2'd2: begin
                    data_out_reg <= data_out_reg + data_in;
                    counter_reg <= counter_reg + 1;
                end
                2'd3: begin
                    data_out_reg <= data_out_reg + data_in;
                    valid_out_reg <= 1'b1;
                    counter_reg <= 2'd0;
                end
            endcase
        end else begin
            counter_reg <= counter_reg;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule