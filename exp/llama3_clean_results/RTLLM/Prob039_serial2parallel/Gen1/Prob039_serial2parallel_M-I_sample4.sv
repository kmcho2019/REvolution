module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [3:0] cnt_reg;
reg [7:0] shift_reg;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_reg <= 4'd0;
        shift_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else begin
        if (din_valid) begin
            shift_reg <= {din_serial, shift_reg[7:1]};
            cnt_reg <= cnt_reg + 1'd1;
            if (cnt_reg == 4'd7) begin
                cnt_reg <= 4'd0;
                dout_valid_reg <= 1'd1;
            end else begin
                dout_valid_reg <= 1'd0;
            end
        end else begin
            cnt_reg <= cnt_reg;
            dout_valid_reg <= 1'd0;
        end
    end
end

assign dout_parallel = shift_reg;
assign dout_valid = dout_valid_reg;

endmodule