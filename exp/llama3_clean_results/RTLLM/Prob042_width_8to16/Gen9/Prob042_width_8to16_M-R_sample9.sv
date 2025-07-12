module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock_reg;
reg flag_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        flag_reg <= 0;
        data_lock_reg <= 0;
    end else if (valid_in) begin
        if (flag_reg) begin
            flag_reg <= 0;
        end else begin
            data_lock_reg <= data_in;
            flag_reg <= 1;
        end
    end
end

assign valid_out = (valid_in && flag_reg);
assign data_out = (valid_in && flag_reg) ? {data_in, data_lock_reg} : 16'b0;

endmodule