module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;  // 4-bit counter
reg [7:0] shift_reg;  // 8-bit shift register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;  // reset counter to 0
        shift_reg <= 8'd0;  // reset shift register to 0
        dout_valid <= 1'b0;  // reset validity signal to 0
    end else if (din_valid) begin
        shift_reg <= {shift_reg[6:0], din_serial};  // shift shift register one position to the left and store new input bit
        cnt <= cnt + 1;  // increment counter
        if (cnt == 4'd8) begin
            dout_parallel <= shift_reg;  // output shift register
            dout_valid <= 1'b1;  // set validity signal to 1
            cnt <= 4'd0;  // reset counter to 0
        end else begin
            dout_valid <= 1'b0;  // set validity signal to 0
        end
    end
end

endmodule