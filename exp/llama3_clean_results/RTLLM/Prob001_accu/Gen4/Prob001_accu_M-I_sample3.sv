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
reg             valid_out_pulse;
reg     [1:0]  counter;
reg     [7:0]  data_shift_reg [3:0];

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out_reg <= 1'b0;
        valid_out_pulse <= 1'b0;
        data_out_reg <= 10'd0;
        counter <= 2'd0;
        for (int i = 0; i < 4; i++) begin
            data_shift_reg[i] <= 8'd0;
        end
    end else begin
        if (valid_in) begin
            if (counter == 2'd0) begin
                data_shift_reg[0] <= data_in;
            end else if (counter == 2'd1) begin
                data_shift_reg[1] <= data_in;
            end else if (counter == 2'd2) begin
                data_shift_reg[2] <= data_in;
            end else if (counter == 2'd3) begin
                data_shift_reg[3] <= data_in;
                data_out_reg <= data_shift_reg[0] + data_shift_reg[1] + data_shift_reg[2] + data_in;
                valid_out_pulse <= 1'b1;
            end
            if (counter < 2'd3) begin
                counter <= counter + 1'd1;
            end else begin
                counter <= 2'd0;
            end
        end
        if (valid_out_pulse) begin
            valid_out_pulse <= 1'b0;
            valid_out_reg <= 1'b1;
        end else if (valid_out_reg) begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;

endmodule