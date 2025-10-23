module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg [7:0] data_in_reg;
reg       valid_lock;
reg       valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        data_in_reg <= 8'd0;
        valid_lock <= 1'b0;
        valid_out_reg <= 1'b0;
    end
    else begin
        if (valid_in) begin
            if (!valid_lock) begin
                data_lock <= data_in;
                valid_lock <= 1'b1;
            end
            else begin
                data_in_reg <= data_in;
                valid_out_reg <= 1'b1;
                valid_lock <= 1'b0; // Reset valid_lock after generating output
            end
        end
        else if (valid_out_reg) begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_lock && valid_in) ? {data_lock, data_in} : (valid_out_reg) ? {data_lock, data_in_reg} : 16'd0;

endmodule