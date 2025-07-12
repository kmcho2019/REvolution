module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] shift_reg;
reg [3:0] cnt;
reg valid_out;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 8'd0;
        cnt <= 4'd0;
        valid_out <= 1'd0;
    end else if (din_valid) begin
        shift_reg <= {shift_reg[6:0], din_serial};
        cnt <= cnt + 1'd1;
        if (cnt == 4'd7) begin
            dout_parallel <= shift_reg;
            valid_out <= 1'd1;
            cnt <= 4'd0;
        end else begin
            valid_out <= 1'd0;
        end
    end else begin
        valid_out <= 1'd0;
    end
end

assign dout_valid = valid_out;

endmodule