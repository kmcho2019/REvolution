module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] shift_register;
reg [3:0] cnt;
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_register <= 8'b0;
        cnt <= 4'b0;
        valid <= 1'b0;
    end else if (din_valid) begin
        shift_register <= {shift_register[6:0], din_serial};
        cnt <= cnt + 1'b1;
        if (cnt == 4'd7) begin
            valid <= 1'b1;
        end else begin
            valid <= 1'b0;
        end
    end else begin
        shift_register <= shift_register;
        cnt <= cnt;
        valid <= 1'b0;
    end
end

assign dout_parallel = shift_register;
assign dout_valid = valid;

endmodule