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

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        shift_reg <= 8'd0;
        valid_out <= 1'b0;
    end else if (din_valid) begin
        shift_reg <= {din_serial, shift_reg[7:1]};
        cnt <= cnt + 1'b1;
        if (cnt == 4'd7) begin
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end else begin
        if (valid_out) begin
            cnt <= 4'd0;
            shift_reg <= 8'd0;
            valid_out <= 1'b0;
        end
    end
end

assign dout_parallel = shift_reg;
assign dout_valid = valid_out;

endmodule