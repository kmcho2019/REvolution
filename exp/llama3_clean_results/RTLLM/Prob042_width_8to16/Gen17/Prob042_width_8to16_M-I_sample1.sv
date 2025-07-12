module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg [7:0] data_out_reg;
reg       data_locked;
reg       valid_out_reg;

assign valid_out = valid_out_reg;
assign data_out = {data_lock, data_in};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        data_out_reg <= 16'd0;
        data_locked <= 1'b0;
        valid_out_reg <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (!data_locked) begin
                data_lock <= data_in;
                data_locked <= 1'b1;
            end
            else begin
                data_out_reg <= {data_lock, data_in};
                valid_out_reg <= 1'b1;
                data_locked <= 1'b0;
            end
        end
        else begin
            valid_out_reg <= 1'b0;
        end
    end
end

endmodule