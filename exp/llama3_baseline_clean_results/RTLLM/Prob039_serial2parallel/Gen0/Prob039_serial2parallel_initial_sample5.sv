module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;  // Counter to keep track of the number of input bits
reg [7:0] shift_reg;  // Register to store the input data bits

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;  // Reset counter
        shift_reg <= 8'd0;  // Reset shift register
        dout_valid <= 1'd0;  // Reset output validity signal
    end else if (din_valid) begin
        shift_reg <= {shift_reg[6:0], din_serial};  // Shift left and insert new data bit
        cnt <= cnt + 1;  // Increment counter

        if (cnt == 4'd7) begin
            cnt <= 4'd0;  // Reset counter
            dout_parallel <= shift_reg;  // Output parallel data
            dout_valid <= 1'd1;  // Set output validity signal
        end else begin
            dout_valid <= 1'd0;  // Clear output validity signal
        end
    end else begin
        dout_valid <= 1'd0;  // Clear output validity signal
    end
end

endmodule