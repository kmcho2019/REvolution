module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg     [9:0]  data_out_reg;
reg             valid_out_reg;
reg     [1:0]  counter;
reg     [7:0]  data_buf [3:0];
reg     [7:0]  data_acc;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out_reg <= 1'b0;
        data_out_reg <= 10'd0;
        counter <= 2'd0;
        data_acc <= 8'd0;
    end else begin
        if (valid_in) begin
            case (counter)
                2'd0: data_buf[0] <= data_in;
                2'd1: data_buf[1] <= data_in;
                2'd2: data_buf[2] <= data_in;
                2'd3: data_buf[3] <= data_in;
            endcase
            if (counter == 2'd3) begin
                data_acc <= data_buf[0] + data_buf[1] + data_buf[2] + data_buf[3];
                valid_out_reg <= 1'b1;
                data_out_reg <= data_acc;
                counter <= 2'd0;
            end else begin
                counter <= counter + 1'd1;
                valid_out_reg <= 1'b0;
            end
        end else begin
            valid_out_reg <= 1'b0;
            if (counter == 2'd0) begin
                data_out_reg <= 10'd0;
            end
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule